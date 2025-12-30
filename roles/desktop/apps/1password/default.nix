{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.onepassword;
in
{
  options.mine.desktop.apps.onepassword = {
    enable = mkEnableOption "1Password (password manager)";
  };

  config = mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ryan" ];
    };

    # allow Edge to conenct with 1password
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          msedge
        '';
        mode = "0755";
      };
    };
  };
}
