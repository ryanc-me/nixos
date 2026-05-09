{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    concatStringsSep
    mapAttrsToList
    ;
  cfg = config.mine.server-auth.services.authentik;
  nginx = config.mine.server-nginx.services.nginx;

  hasHttpScheme = s: lib.hasPrefix "http://" s || lib.hasPrefix "https://" s;

  mkExternalUrl =
    name: url:
    if hasHttpScheme url then url else "https://${url}.${config.mine.server-nginx.domainBase}";

  mkIconUrl =
    icon:
    if icon == null then
      ""
    else if hasHttpScheme icon then
      icon
    else
      "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/${icon}.svg";

  indentString = n: lib.concatStrings (lib.genList (_: " ") n);

  renderYamlAttrs =
    indent: attrs:
    concatStringsSep "\n" (
      mapAttrsToList (k: v: "${indentString indent}${k}: ${builtins.toJSON v}") attrs
    );

  mkGroupFind =
    groupName: "            - !Find [authentik_core.group, [name, ${builtins.toJSON groupName}]]";

  mkProxyBlueprint =
    name: app:
    let
      orDefault = default: value: if value == null then default else value;

      pretty = orDefault name app.namePretty;
      slug = orDefault name app.slug;
      externalHost = mkExternalUrl name (orDefault name app.url);
      iconUrl = mkIconUrl (orDefault name app.icon);

      providerAttrs = {
        name = pretty;
        mode = app.mode;
        external_host = externalHost;
        internal_host = "";
        internal_host_ssl_validation = true;
        intercept_header_auth = true;
        cookie_domain = app.cookieDomain;
        basic_auth_enabled = false;
        skip_path_regex = app.skipPathRegex;
      }
      // app.providerAttrs;

      applicationAttrs = {
        name = pretty;
        slug = slug;
        group = app.group;
        meta_icon = iconUrl;
        meta_launch_url = app.launchUrl;
        open_in_new_tab = app.openInNewTab;
        policy_engine_mode = app.policyEngineMode;
      }
      // app.applicationAttrs;
    in
    pkgs.writeText "authentik-${slug}.yaml" ''
      version: 1
      metadata:
        name: ${slug}
        labels:
          blueprints.goauthentik.io/instantiate: "true"

      entries:
        - model: authentik_providers_proxy.proxyprovider
          identifiers:
            name: ${builtins.toJSON pretty}
          attrs:
      ${renderYamlAttrs 6 providerAttrs}
            authorization_flow: !Find [authentik_flows.flow, [slug, ${builtins.toJSON app.authorizationFlow}]]
            invalidation_flow: !Find [authentik_flows.flow, [slug, ${builtins.toJSON app.invalidationFlow}]]
            ${lib.optionalString (app.authenticationFlow != null) ''
              authentication_flow: !Find [authentik_flows.flow, [slug, ${builtins.toJSON app.authenticationFlow}]]
            ''}

        - model: authentik_core.application
          identifiers:
            slug: ${builtins.toJSON slug}
          attrs:
      ${renderYamlAttrs 6 applicationAttrs}
            provider: !Find [authentik_providers_proxy.proxyprovider, [name, ${builtins.toJSON pretty}]]
      ${lib.optionalString (app.assignedGroups != [ ]) ''
            groups:
        ${concatStringsSep "\n" (map mkGroupFind app.assignedGroups)}
      ''}
      ${app.extraYaml or ""}
    '';

  blueprintsDir = "/var/lib/authentik/blueprints-custom";
  lockFile = "/run/authentik-blueprints.lock";

  generatedProxyBlueprints = lib.mapAttrs' (
    name: app: lib.nameValuePair "proxy-${name}" (mkProxyBlueprint name app)
  ) cfg.proxyApplications;

  generatedBlueprints = generatedProxyBlueprints // {
    outpost-providers = mkOutpostBlueprint;
  };

  copyCustomBlueprints = concatStringsSep "\n" (
    mapAttrsToList (name: path: ''
      install -m 0644 ${path} "$tmp/${name}.yaml"
    '') generatedBlueprints
  );

  prepareBlueprintsScript = pkgs.writeShellScript "prepare-authentik-blueprints" ''
    set -euo pipefail

    exec 9>${lockFile}
    ${pkgs.util-linux}/bin/flock 9

    tmp="$(mktemp -d /var/lib/authentik/blueprints-custom.tmp.XXXXXX)"
    trap 'rm -rf "$tmp"' EXIT

    cp -r --no-preserve=mode,ownership \
      ${config.services.authentik.authentikComponents.staticWorkdirDeps}/blueprints/. \
      "$tmp/"

    ${copyCustomBlueprints}

    chown -R root:root "$tmp"
    find "$tmp" -type d -exec chmod 0755 {} +
    find "$tmp" -type f -exec chmod 0644 {} +

    rm -rf ${blueprintsDir}.old
    if [ -e ${blueprintsDir} ]; then
      mv ${blueprintsDir} ${blueprintsDir}.old
    fi
    mv "$tmp" ${blueprintsDir}
    rm -rf ${blueprintsDir}.old

    trap - EXIT
  '';

  mkProviderName =
    name: app:
    let
      orDefault = default: value: if value == null then default else value;
    in
    orDefault name app.namePretty;

  mkProviderFind =
    provider:
    let
      model =
        if provider.model == "proxy" then
          "authentik_providers_proxy.proxyprovider"
        else if provider.model == "oauth2" then
          "authentik_providers_oauth2.oauth2provider"
        else
          throw "Unsupported authentik provider model: ${provider.model}";
    in
    "              - !Find [${model}, [name, ${builtins.toJSON provider.name}]]";

  generatedProxyProviders = mapAttrsToList (name: app: {
    model = "proxy";
    name = mkProviderName name app;
  }) cfg.proxyApplications;

  outpostProviders = generatedProxyProviders ++ cfg.outpostExtraProviders;

  mkOutpostBlueprint = pkgs.writeText "authentik-outpost-providers.yaml" ''
      version: 1
      metadata:
        name: outpost-providers
        labels:
          blueprints.goauthentik.io/instantiate: "true"

      entries:
        - model: authentik_outposts.outpost
          identifiers:
            name: authentik Embedded Outpost
          attrs:
            providers:
    ${concatStringsSep "\n" (map mkProviderFind outpostProviders)}
  '';
in
{
  options.mine.server-auth.services.authentik = {
    enable = mkEnableOption "authentik service";

    outpostExtraProviders = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            model = mkOption {
              type = types.enum [
                "proxy"
                "oauth2"
              ];
              default = "proxy";
            };

            name = mkOption {
              type = types.str;
            };
          };
        }
      );
      default = [ ];
    };

    proxyApplications = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            namePretty = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            slug = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            icon = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            url = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            group = mkOption {
              type = types.str;
              default = "Home";
            };
            mode = mkOption {
              type = types.str;
              default = "forward_single";
            };
            cookieDomain = mkOption {
              type = types.str;
              default = "";
            };
            skipPathRegex = mkOption {
              type = types.str;
              default = "";
            };

            assignedGroups = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            providerAttrs = mkOption {
              type = types.attrs;
              default = { };
            };
            applicationAttrs = mkOption {
              type = types.attrs;
              default = { };
            };
            extraYaml = mkOption {
              type = types.lines;
              default = "";
            };

            launchUrl = mkOption {
              type = types.str;
              default = "";
            };

            openInNewTab = mkOption {
              type = types.bool;
              default = false;
            };

            policyEngineMode = mkOption {
              type = types.str;
              default = "any";
            };

            authenticationFlow = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            authorizationFlow = mkOption {
              type = types.str;
              default = "default-provider-authorization-implicit-consent";
            };

            invalidationFlow = mkOption {
              type = types.str;
              default = "default-provider-invalidation-flow";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {

    sops.secrets."authentik-env" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/authentik.env;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/authentik 0755 root root - -"
      "d /var/lib/authentik/certs 0750 authentik authentik - -"
      "d ${blueprintsDir} 0755 root root - -"
    ];

    systemd.services.authentik.serviceConfig.ExecStartPre = lib.mkBefore [
      "+${prepareBlueprintsScript}"
    ];

    systemd.services.authentik-worker.serviceConfig.ExecStartPre = lib.mkBefore [
      "+${prepareBlueprintsScript}"
    ];

    services.authentik = {
      enable = true;

      environmentFile = config.sops.secrets."authentik-env".path;

      nginx.enable = false; # we'll do it ourselves
      settings = {
        blueprints_dir = "/var/lib/authentik/blueprints-custom";
        cert_discovery_dir = "/var/lib/authentik/certs";
        cookie_domain = config.mine.server-nginx.domainBase;
        listen = {
          http = "127.0.0.1:5080";
          https = "127.0.0.1:5443";
        };
      };
    };

    services.nginx = {
      virtualHosts."auth.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/" = {
          proxyPass = "https://127.0.0.1:5443";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}
