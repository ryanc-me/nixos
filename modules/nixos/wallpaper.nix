# modules/ui/wallpaper.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  mkPct = n: if builtins.isString n then n else builtins.toString n;
  mkInt = n: builtins.toString n;

  my = config.my;

  # blurSigma = my.wallpaper.blur * my.screenScale / 2 - 0.000001;
  blurSigma = my.wallpaper.blur * (my.wallpaper.sizeW / my.screenW) / 2 - 0.000001;
  cropOffsetX = (my.wallpaper.sizeW - my.screenW) / 2;
  cropOffsetY = (my.wallpaper.sizeH - my.screenH) / 2;

  processedPlain =
    pkgs.runCommand "wallpaper-processed-plain" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers
        magick ${my.wallpaper.path} \
          -crop ${mkInt my.screenW}x${mkInt my.screenH}+${mkInt cropOffsetX}+${mkInt cropOffsetY} \
          $out/share/wallpapers/plain.png
      '';

  scaledScreenW = my.screenW / my.screenScale;
  scaledScreenH = my.screenH / my.screenScale;
  processedBlurred =
    pkgs.runCommand "wallpaper-processed-blurred" { buildInputs = [ pkgs.imagemagick ]; }
      ''
        set -eu
        mkdir -p $out/share/wallpapers
        magick ${my.wallpaper.path} \
          -fill black -colorize ${mkPct my.wallpaper.darken}% \
          -blur 0x${mkInt blurSigma} \
          -crop ${mkInt my.screenW}x${mkInt my.screenH}+${mkInt cropOffsetX}+${mkInt cropOffsetY} \
          -resize ${mkInt scaledScreenW}x${mkInt scaledScreenH} \
          $out/share/wallpapers/blurred.png
      '';
in
{
  options.my = {
    # screenW/screenH used for some Gnome/GDM fuckery
    screenW = lib.mkOption {
      type = lib.types.ints.positive;
      default = 3840;
      description = "The (primary) screen width, in pixels";
    };
    screenH = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2160;
      description = "The (primary) screen height, in pixels";
    };
    screenScale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "The (primary) screen scale, as a float";
    };
    wallpaper = {
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
        plain = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the plain wallpaper (for Gnome)";
        };
        blurred = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "Store path for the blurred wallpaper (for GDM)";
        };
      };
    };
  };

  config = lib.mkIf my.wallpaper.enable {
    my.wallpaper.processed = {
      plain = processedPlain;
      blurred = processedBlurred;
    };
  };
}
