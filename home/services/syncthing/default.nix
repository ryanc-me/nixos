{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  # syncthing is a little special, for two reasons:
  #
  # 1. the nixpkgs version doesn't support setting password via file (only via
  #    attrs directly), which does not work with nix-sops. so, I'm using the
  #    home-manager syncthing package (it does also simplify permissions a bit)
  #
  # 2. this module can only really be enabled for my user, unlike the other
  #    home-manager modules (which should be multi-user).
  #
  # as a result, the *enable* option for syncthing is on the NixOS side, but the
  # definition itself is here.

  config =
    mkIf
      (
        osConfig.mine ? desktop
        && osConfig.mine.desktop.services.syncthing.enable
        && config.home.username == "ryan"
      )
      {
        sops = {
          secrets = {
            "guiPassword" = {
              sopsFile = ../../../secrets/syncthing.yaml;
            };
            "${osConfig.networking.hostName}/key" = {
              sopsFile = ../../../secrets/syncthing.yaml;
            };
            "${osConfig.networking.hostName}/cert" = {
              sopsFile = ../../../secrets/syncthing.yaml;
            };
          };
        };

        services.syncthing = {
          enable = true;
          key = config.sops.secrets."${osConfig.networking.hostName}/key".path;
          cert = config.sops.secrets."${osConfig.networking.hostName}/cert".path;
          overrideFolders = true;
          overrideDevices = true;
          passwordFile = config.sops.secrets."guiPassword".path;
          settings = {
            options = {
              urAccepted = -1;
              relaysEnabled = false;
              globalAnnounceEnabled = false;
              localAnnounceEnabled = false;
            };
            devices = {
              "heibohre" = {
                id = "3LB2MBF-YOOEMJG-IQBI4QC-S3PYACP-MM2AJ3P-LFVXP26-V2IMWJN-JYJBXQF";
                addresses = [
                  "tcp4://heibohre.lan:22000"
                  "quic4://heibohre.lan:22000"
                ];
              };
              "sorpen" = {
                id = "RFBG4OC-B4E4TY5-2TKYJNU-4RRTGTO-W4DETHH-BBGVEIK-P7GUJC6-EGWI5A2";
                addresses = [
                  "tcp4://mixeto.lan:22000"
                  "quic4://mixeto.lan:22000"
                  "tcp4://mixeto.io:22000"
                  "quic4://mixeto.io:22000"
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
              work = {
                id = "ckker-ntjru";
                path = "${config.home.homeDirectory}/work";
                devices = [
                  "heibohre"
                  "idir"
                  "sorpen"
                  "aquime"
                ];
              };
              calibre = {
                id = "ou3jn-qhrwn";
                path = "${config.home.homeDirectory}/calibre";
                devices = [
                  "heibohre"
                  "idir"
                  "sorpen"
                  "aquime"
                ];
              };
              temp = {
                id = "gtlm3-cyz4n";
                path = "${config.home.homeDirectory}/temp";
                devices = [
                  "heibohre"
                  "idir"
                  "sorpen"
                  "aquime"
                ];
              };
              projects = {
                id = "ibzk4-hgtmj";
                path = "${config.home.homeDirectory}/projects";
                devices = [
                  "heibohre"
                  "idir"
                  "sorpen"
                  "aquime"
                ];
              };
              dot-ssh = {
                label = ".ssh";
                id = "wpaud-nunjg";
                path = "${config.home.homeDirectory}/.ssh";
                devices = [
                  "heibohre"
                  "idir"
                  "sorpen"
                  "aquime"
                ];
              };
            };
          };
        };
      };
}
