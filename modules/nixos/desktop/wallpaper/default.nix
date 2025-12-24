{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;

  mkPct = n: if builtins.isString n then n else builtins.toString n;
  mkInt = n: builtins.toString n;

  dp = config.mine.desktop.display;
  wp = config.mine.desktop.wallpaper;

  blurSigma = wp.blur * (wp.sizeW / dp.screenW) / 2 - 0.000001;
  cropOffsetX = (dp.sizeW - dp.screenW) / 2;
  cropOffsetY = (dp.sizeH - dp.screenH) / 2;

  scaledScreenW = dp.screenW / dp.screenScale;
  scaledScreenH = dp.screenH / dp.screenScale;

  processedPlainCentered =
    pkgs.runCommand "wallpaper-processed-plain-centered" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers
        magick ${wp.path} \
          -crop ${mkInt dp.screenW}x${mkInt dp.screenH}+${mkInt cropOffsetX}+${mkInt cropOffsetY} \
          -resize ${mkInt scaledScreenW}x${mkInt scaledScreenH} \
          $out/share/wallpapers/plain.png
      '';
  processedPlainZoom =
    pkgs.runCommand "wallpaper-processed-plain-zoom" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers
        magick ${wp.path} \
          -resize ${mkInt scaledScreenW}x${mkInt scaledScreenH} \
          $out/share/wallpapers/plain.png
      '';

  processedBlurredCentered =
    pkgs.runCommand "wallpaper-processed-blurred-centered" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers

        magick ${wp.path} \
          -fill black -colorize ${mkPct wp.darken}% \
          -blur 0x${mkInt blurSigma} \
          -crop ${mkInt dp.screenW}x${mkInt dp.screenH}+${mkInt cropOffsetX}+${mkInt cropOffsetY} \
          -resize ${mkInt scaledScreenW}x${mkInt scaledScreenH} \
          $out/share/wallpapers/blurred.png
      '';
  processedBlurredZoom =
    pkgs.runCommand "wallpaper-processed-blurred-zoom" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers

        magick ${wp.path} \
          -fill black -colorize ${mkPct wp.darken}% \
          -blur 0x${mkInt blurSigma} \
          -resize ${mkInt scaledScreenW}x${mkInt scaledScreenH} \
          $out/share/wallpapers/blurred.png
      '';
in
{
  options.mine.desktop.wallpaper = {
    enable = lib.mkEnableOption "shared wallpaper processing";

    path = lib.mkOption {
      type = lib.types.path;
      description = "source image";
    };
    sizeW = lib.mkOption {
      type = lib.types.ints.positive;
      default = 3840;
      description = "Wallpaper image width, in pixels.";
    };
    sizeH = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2160;
      description = "Wallpaper image height, in pixels.";
    };
    blur = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "ImageMagick blur radius (sigma)";
    };
    darken = lib.mkOption {
      type = lib.types.int;
      default = 40;
      description = "black veil percent (0-100)";
    };
    mode = lib.mkOption {
      type = lib.types.enum [
        "centered"
        "zoom"
      ];
      default = "zoom";
      description = "How to display the wallpaper (for Gnome)";
    };

    processed = {
      plain = {
        centered = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the plain + centered wallpaper (for Gnome)";
        };
        zoom = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the plain + zoom wallpaper (for Gnome)";
        };
      };
      blurred = {
        centered = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the blurred + centered wallpaper (for GDM)";
        };
        zoom = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the blurred + zoom wallpaper (for GDM)";
        };
      };
    };
  };

  config = lib.mkIf wp.enable {
    mine.desktop.wallpaper.processed = {
      plain = {
        centered = processedPlainCentered;
        zoom = processedPlainZoom;
      };
      blurred = {
        centered = processedBlurredCentered;
        zoom = processedBlurredZoom;
      };
    };
  };
}
