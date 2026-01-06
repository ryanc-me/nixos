{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.unpackerr;
  isCustomDataDir = cfg.dataDir != "/var/lib/unpackerr";
in
{
  options = {
    services.unpackerr = {
      enable = lib.mkEnableOption "unpackerr, archive extraction daemon";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/unpackerr";
        description = ''
          The directory where Prowlarr stores its data files.

          Note: A bind mount will be used to mount the directory at the expected location
          if a different value than `/var/lib/unpackerr` is used.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.dataDir}/unpackerr.toml";
        description = "Location of Unpackerr's configuration file.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.str;
        description = "Location of Unpackerr's environment file.";
      };

      package = lib.mkPackageOption pkgs "unpackerr" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "unpackerr";
        description = "User account under which Unpackerr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "unpackerr";
        description = "Group under which Unpackerr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.unpackerr = {
        description = "unpackerr - archive extraction daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = "${lib.getExe cfg.package} --config ${cfg.configFile}";
          Restart = "on-failure";
        };
      };

      tmpfiles.settings."10-unpackerr".${cfg.dataDir}.d = lib.mkIf isCustomDataDir {
        user = "root";
        group = "root";
        mode = "0700";
      };

      mounts = lib.optional isCustomDataDir {
        what = cfg.dataDir;
        where = "/var/lib/private/prowlarr";
        options = "bind";
        wantedBy = [ "local-fs.target" ];
      };
    };

    users.users = lib.mkIf (cfg.user == "unpackerr") {
      unpackerr = {
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = false;
        group = cfg.group;
      };
    };
    users.groups = lib.mkIf (cfg.group == "unpackerr") {
      unpackerr = {  };
    };
  };
}