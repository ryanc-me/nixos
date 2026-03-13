{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.screenshot;
  niriEnabled = osConfig.mine ? desktop-niri && osConfig.mine.desktop-niri.enable;
in
{
  config = mkIf (cfg.enable && niriEnabled) {
    # req's
    home.packages = with pkgs; [
      inotify-tools
      satty
      wl-clipboard
    ];

    # screenshot script
    home.file.".local/bin/screenshot.hm-init" = {
      text = ''
        #!/usr/bin/env bash
        set -e

        screenshot_dir="/home/ryan/Pictures/Screenshots"
        filename_base="screenshot_$(date '+%Y-%m-%d_%H-%M-%S')"
        outfile="$screenshot_dir/$filename_base.png"
        outfile_edited="$screenshot_dir/$filename_base.edited.png"

        # screenshot
        niri msg action screenshot --path "$outfile"

        sleep 1

        # edit/annotate
        satty \
            --filename "$outfile" \
            --output-filename "$outfile_edited" \
            --initial-tool rectangle \
            --actions-on-escape save-to-file,exit \
            --actions-on-enter save-to-file,exit \
            --no-window-decoration

        # copy to clipboard
        wl-copy < "$outfile_edited"

        # notification (click to open containing folder)
        action=$(notify-send "Screenshot" "$(basename "$outfile_edited")" -i image-x-generic -a "screenshot" -t 5000 --action=open_folder="View Screenshot")
        if [ "$action" = "open_folder" ]; then
            xdg-open "$(dirname "$outfile_edited")"
        fi
      '';
      onChange = ''
        rm -f .local/bin/screenshot
        cp .local/bin/screenshot.hm-init .local/bin/screenshot
        chmod u+x .local/bin/screenshot
      '';
    };
  };
}
