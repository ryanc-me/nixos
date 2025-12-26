{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.system.firewall;
in
{
  options.mine.nixos.system.firewall = {
    enable = mkEnableOption "Enable system firewall";
  };

  # TODO: can we define the ports in modules/home, then aggregate them here?
  config = mkIf config.mine.nixos.system.firewall.enable {
    networking.firewall = {
      enable = true;
    };
  };
}
