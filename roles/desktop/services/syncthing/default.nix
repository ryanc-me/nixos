{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.services.syncthing;
in
{
  # https://wiki.nixos.org/wiki/Syncthing
  options.mine.desktop.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = {
        "guiPassword" = {
          sopsFile = ../../../../secrets/syncthing.yaml;
        };
        "${config.networking.hostName}/key" = {
          sopsFile = ../../../../secrets/syncthing.yaml;
        };
        "${config.networking.hostName}/cert" = {
          sopsFile = ../../../../secrets/syncthing.yaml;
        };
      };
    };

    services.syncthing = {
      enable = true;
      key = config.sops.secrets."${config.networking.hostName}/key".path;
      cert = config.sops.secrets."${config.networking.hostName}/cert".path;
      guiPasswordFile = config.sops.secrets."guiPassword".path;

      overrideFolders = true;
      overrideDevices = true;
      openDefaultPorts = true;

      # explicitly disable relays
      relay.enable = false;

      settings = {
        options = {
          urAccepted = -1;
          relaysEnabled = false;
          globalAnnounceEnabled = false;
          localAnnounceEnabled = false;
          syncOwnership = true;
        };

        devices = {
          "masaq" = {
            id = "RFBG4OC-B4E4TY5-2TKYJNU-4RRTGTO-W4DETHH-BBGVEIK-P7GUJC6-EGWI5A2";
            addresses = [
              "tcp4://masaq.lan:22000"
              "quic4://masaq.lan:22000"
              "tcp4://mixeto.io:22000"
              "quic4://mixeto.io:22000"

              # temporary, until the server can be rebooted
              "tcp4://mixeto.lan:22000"
              "quic4://mixeto.lan:22000"
            ];
          };
          "idir" = {
            id = "KXVJMSK-KZNDPGX-6APM7ZC-2TW4WRY-6CC2MNN-S6RIHYA-SBLRVMZ-QCE5AAQ";
            addresses = [
              "tcp4://idir.lan:22000"
              "quic4://idir.lan:22000"
            ];
          };
          "aquime" = {
            id = "YSQAPOZ-DAVEHJD-LICYVXV-6FGPYYT-R7QDGID-QCOVPHI-QM6NBHZ-QI5B2A6";
            addresses = [
              "tcp4://aquime.lan:22000"
              "quic4://aquime.lan:22000"
            ];
          };
        };

        folders = {
          device-sync = {
            id = "7fyge-wyo4h";
            path = "/persist/sync/";
            devices = [
              "idir"
              "masaq"
              "aquime"
            ];
          };
        };
      };
    };

    # sudo setfacl -R -m u:syncthing:rwx /persist/sync
    # sudo setfacl -R -m d:u:syncthing:rwx /persist/sync
    systemd.tmpfiles.rules = [
      "d /persist/sync 0755 syncthing syncthing -"
      "d /persist/local 0755 root root -"
    ];

    system.activationScripts.impermanence-sync-acl.text = ''
      ${pkgs.acl}/bin/setfacl -R -m u:syncthing:rwX /persist/sync || true
      ${pkgs.acl}/bin/setfacl -R -m d:u:syncthing:rwX /persist/sync || true
    '';

    systemd.services.syncthing.serviceConfig = {
      # so syncthing can set ownership of files/dirs
      AmbientCapabilities = [
        "CAP_CHOWN"
        "CAP_FOWNER"
      ];

      # limit access to these folders
      ProtectSystem = "strict";
      ReadWritePaths = [
        "/persist/sync"
        config.services.syncthing.configDir
        config.services.syncthing.dataDir
        config.services.syncthing.databaseDir
      ];

      # so we know about other users (for ownership)
      PrivateUsers = lib.mkForce false;
    };

    systemd.services.syncthing.unitConfig = {
      RequiresMountsFor = "/persist/sync";
      ConditionPathIsDirectory = "/persist/sync";
    };
  };
}
