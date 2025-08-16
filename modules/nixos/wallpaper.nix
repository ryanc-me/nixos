# modules/ui/wallpaper.nix
{ lib, pkgs, config, ... }:
let
  cfg = config.my.wallpaper;
  mkPct = n: if builtins.isString n then n else builtins.toString n;
  mkInt = n: builtins.toString n;
  processed =
    pkgs.runCommand "wallpaper-processed"
      { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers
        # blur, then darken (veil)
        convert ${cfg.path} \
          -blur 0x${mkInt cfg.blur} \
          -fill black -colorize ${mkPct cfg.darken}% \
          $out/share/wallpapers/greeter-wallpaper.jpg
      '';
in
{
  options.my.wallpaper = {
    enable = lib.mkEnableOption "shared wallpaper processing";
    path   = lib.mkOption { type = lib.types.path; description = "source image"; };
    blur   = lib.mkOption { type = lib.types.int;  default = 8;  description = "ImageMagick blur radius (sigma)"; };
    darken = lib.mkOption { type = lib.types.int;  default = 30; description = "black veil percent (0-100)"; };
    processedPath = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = "store path containing processed image";
    };
  };

  config = lib.mkIf cfg.enable {
    my.wallpaper.processedPath = processed;
  };
}