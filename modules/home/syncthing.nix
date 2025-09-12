{ config, pkgs, osConfig, ... }:

{
  sops = {
    secrets = {
      "guiPassword" = {
        sopsFile = ../../secrets/syncthing.yaml;
      };
      "${osConfig.networking.hostName}/key" = {
        sopsFile = ../../secrets/syncthing.yaml;
      };
      "${osConfig.networking.hostName}/cert" = {
        sopsFile = ../../secrets/syncthing.yaml;
      };
    };
  };

  services.syncthing = {
    enable = true;
    key = config.sops.secrets."${osConfig.networking.hostName}/key".path;
    cert = config.sops.secrets."${osConfig.networking.hostName}/cert".path;
    extraOptions = [ "--no-default-folder" ];
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
            "tcp4://ryan-pc.lan:22000"
            "quic4://ryan-pc.lan:22000"
          ];
        };
      };
      folders = {
        work = {
          id = "ckker-ntjru";
          path = "${config.home.homeDirectory}/work";
          devices = [ "heibohre" "idir" "sorpen" ];
        };
        calibre = {
          id = "ou3jn-qhrwn";
          path = "${config.home.homeDirectory}/calibre";
          devices = [ "heibohre" "idir" "sorpen" ];
        };
        temp = {
          id = "gtlm3-cyz4n";
          path = "${config.home.homeDirectory}/temp";
          devices = [ "heibohre" "idir" "sorpen" ];
        };
        projects = {
          id = "ibzk4-hgtmj";
          path = "${config.home.homeDirectory}/projects";
          devices = [ "heibohre" "idir" "sorpen" ];
        };
        dot-ssh = {
          label = ".ssh";
          id = "wpaud-nunjg";
          path = "${config.home.homeDirectory}/.ssh";
          devices = [ "heibohre" "idir" "sorpen" ];
        };
      };
    };
  };
}