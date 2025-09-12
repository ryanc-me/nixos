{ config, pkgs, ... }:

{
  # req's
  home.packages = with pkgs; [
    gnome-screenshot
    swappy
    wl-clipboard
    satty
  ];

  # screenshot script
  home.file.".local/bin/screenshot.hm-init" = {
    text = ''
      #!/usr/bin/env bash

      tmpfile=$(mktemp -u --suffix=.png)
      outfile=~/Pictures/Screenshots/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png
      gnome-screenshot -a -f $tmpfile
      satty -f $tmpfile -o $outfile --initial-tool rectangle --actions-on-escape save-to-clipboard,save-to-file,exit --actions-on-enter save-to-clipboard,save-to-file,exit  --no-window-decoration
      rm $tmpfil
    '';
    onChange = ''
      rm -f .local/bin/screenshot
      cp .local/bin/screenshot.hm-init .local/bin/screenshot
      chmod u+x .local/bin/screenshot
    '';
  };

  #TODO: keybinds
}

