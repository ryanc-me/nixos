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
in
{
  options.mine.home.apps.screenshot = {
    enable = mkEnableOption "screenshot (custom script)";
  };

  config = mkIf cfg.enable {
    # req's
    home.packages = with pkgs; [
      cosmic-screenshot
      inotify-tools
      satty
      wl-clipboard
    ];

    # screenshot script
    home.file.".local/bin/screenshot.hm-init" = {
      text = ''
        #!/usr/bin/env bash
        set -e

        # note, must be in ~/
        screenshot_dir="/home/ryan/Pictures/Screenshots"

        # tmpfiles and outfile
        outfile="$screenshot_dir/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
        fifo=$(mktemp -u)
        mkfifo "$fifo"

        # cleanup
        cleanup() {
          echo "Cleaning up..."
          rm -f "$tmpfile"
          rm -f "$fifo"
        }
        trap cleanup EXIT

        # watch for new files
        (
          timeout 300 inotifywait \
            -q \
            -e close_write,create \
            --format '%w%f' \
            "$screenshot_dir" \
        ) >"$fifo" &
        watcher_pid=$!

        # screenshot
        cosmic-screenshot --notify=false --save-dir "$screenshot_dir"

        if ! read -r new_file <"$fifo"; then
          echo "No new screenshot detected (did you cancel?)." >&2
          # In case the watcher is still around
          kill "$watcher_pid" 2>/dev/null || true
          exit 1
        fi

        # make sure watcher is dead
        kill "$watcher_pid" 2>/dev/null || true

        if [[ ! -f "$new_file" ]]; then
          echo "Watcher reported '$new_file', but it doesn't exist." >&2
          exit 1
        fi

        # edit/annotate
        satty \
            --filename "$new_file" \
            --output-filename "$outfile" \
            --initial-tool rectangle \
            --actions-on-escape save-to-file,exit \
            --actions-on-enter save-to-file,exit \
            --no-window-decoration

        rm -f "$new_file"

        # copy to clipboard
        wl-copy < "$outfile"

        # notification (click to open containing folder)
        action=$(notify-send "Screenshot" "$(basename "$outfile")" -i image-x-generic -a "screenshot" -t 5000 --action=open_folder="View Screenshot")
        if [ "$action" = "open_folder" ]; then
            xdg-open "$(dirname "$outfile")"
        fi
      '';
      onChange = ''
        rm -f .local/bin/screenshot
        cp .local/bin/screenshot.hm-init .local/bin/screenshot
        chmod u+x .local/bin/screenshot
      '';
    };

    dconf.settings = mkIf osConfig.mine.nixos.desktop.gnome.enable {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom0" = {
        binding = "Print";
        command = "screenshot";
        name = "Screenshot";
      };
    };
  };
}
