{ config, pkgs, ... }:

{
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
}
