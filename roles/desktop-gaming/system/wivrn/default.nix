{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.desktop-gaming.system.wivrn;
in

{
  options.mine.desktop-gaming.system.wivrn = {
    enable = mkEnableOption "wivrn";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xrizer
      wayvr
    ];
    services.wivrn = {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;

      autoStart = true;

      package = (pkgs.wivrn.override { cudaSupport = true; });
    };
  };
}
