{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.system.fonts;
in
{
  options.mine.home.system.fonts = {
    enable = mkEnableOption "custom fonts";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      satdump
    ];
  };
}
