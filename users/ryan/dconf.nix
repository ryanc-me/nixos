# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };

      "org/gnome/desktop/interface" = {
        clock-show-seconds = true;
        cursor-theme = "Capitaine Cursors";
        cursor-size = lib.gvariant.mkInt32 24;
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        maximize = [ "<Super>Up" ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 4;
        resize-with-right-button = true;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        edge-tiling = false;
        experimental-features = [
          "scale-monitor-framebuffer"
          "variable-refresh-rate"
          "xwayland-native-scaling"
        ];
        workspaces-only-on-primary = true;
      };

      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small-plus";
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        migrated-gtk-settings = true;
        search-filter-time-type = "last_modified";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "Print";
        command = "/home/ryan/.local/bin/screenshot";
        name = "Screenshot";
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = false;
        brightness = 0.27;
        enable-all = true;
        opacity = 200;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = false;
        brightness = 0.6;
        pipeline = "pipeline_default_rounded";
        sigma = 30;
        static-blur = true;
        style-dash-to-dock = 0;
        unblur-in-overview = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
        blur-original-panel = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
        compatibility = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        blur = true;
        pipeline = "pipeline_default";
        style-components = 1;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        force-light-text = true;
        override-background-dynamically = false;
        pipeline = "pipeline_default";
        sigma = 30;
        static-blur = true;
        unblur-in-overview = true;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/caffeine" = {
        indicator-position-max = 4;
        user-enabled = true;
      };

      "org/gnome/shell/extensions/clipboard-indicator" = {
        clear-history = [ ];
        enable-keybindings = true;
        move-item-first = true;
        next-entry = [ ];
        prev-entry = [ ];
        preview-size = 50;
        private-mode-binding = [ ];
        toggle-menu = [ "<Super>v" ];
      };

      "org/gnome/shell/extensions/forge" = {
        css-last-update = mkUint32 37;
        css-updated = "1757282802451";
        float-always-on-top-enabled = false;
        focus-border-toggle = false;
        move-pointer-focus-enabled = false;
        split-border-toggle = true;
        stacked-tiling-mode-enabled = false;
        tabbed-tiling-mode-enabled = false;
        tiling-mode-enabled = true;
        window-gap-hidden-on-single = false;
        window-gap-size = mkUint32 5;
        window-gap-size-increment = mkUint32 1;
      };

      "org/gnome/shell/extensions/forge/keybindings" = {
        con-split-horizontal = [ "<Super>z" ];
        con-split-layout-toggle = [ "<Super>g" ];
        con-split-vertical = [ "<Super>v" ];
        con-stacked-layout-toggle = [ "<Shift><Super>s" ];
        con-tabbed-layout-toggle = [ "<Shift><Super>t" ];
        con-tabbed-showtab-decoration-toggle = [ "<Control><Alt>y" ];
        focus-border-toggle = [ "<Super>x" ];
        mod-mask-mouse-tile = "Super";
        prefs-tiling-toggle = [ "<Super>w" ];
        window-focus-down = [ "<Super>j" ];
        window-focus-left = [ "<Super>h" ];
        window-focus-right = [ "<Super>l" ];
        window-focus-up = [ "<Super>k" ];
        window-gap-size-decrease = [ "<Control><Super>minus" ];
        window-gap-size-increase = [ "<Control><Super>plus" ];
        window-move-down = [ "<Shift><Super>j" ];
        window-move-left = [ "<Shift><Super>h" ];
        window-move-right = [ "<Shift><Super>l" ];
        window-move-up = [ "<Shift><Super>k" ];
        window-resize-bottom-decrease = [ "<Shift><Control><Super>i" ];
        window-resize-bottom-increase = [ "<Control><Super>u" ];
        window-resize-left-decrease = [ "<Shift><Control><Super>o" ];
        window-resize-left-increase = [ "<Control><Super>y" ];
        window-resize-right-decrease = [ "<Shift><Control><Super>y" ];
        window-resize-right-increase = [ "<Control><Super>o" ];
        window-resize-top-decrease = [ "<Shift><Control><Super>u" ];
        window-resize-top-increase = [ "<Control><Super>i" ];
        window-snap-center = [ "<Control><Alt>c" ];
        window-snap-one-third-left = [ "<Control><Alt>d" ];
        window-snap-one-third-right = [ "<Control><Alt>g" ];
        window-snap-two-third-left = [ "<Control><Alt>e" ];
        window-snap-two-third-right = [ "<Control><Alt>t" ];
        window-swap-down = [ "<Control><Super>j" ];
        window-swap-last-active = [ "<Super>Return" ];
        window-swap-left = [ "<Control><Super>h" ];
        window-swap-right = [ "<Control><Super>l" ];
        window-swap-up = [ "<Control><Super>k" ];
        window-toggle-always-float = [ "<Shift><Super>c" ];
        window-toggle-float = [ "<Super>c" ];
        workspace-active-tile-toggle = [ "<Shift><Super>w" ];
      };

      "org/gnome/shell/extensions/just-perfection" = {
        accessibility-menu = false;
        clock-menu = true;
        dash = false;
        dash-icon-size = 16;
        panel = true;
        panel-in-overview = true;
        ripple-box = false;
        search = false;
        show-apps-button = false;
        startup-status = 0;
        support-notifier-showed-version = 34;
        support-notifier-type = 0;
        theme = true;
        window-demands-attention-focus = true;
        window-picker-icon = true;
        workspace = true;
        workspaces-in-app-grid = false;
      };

      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        screenshot-window = [ ];
        show-screenshot-ui = [ ];
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        toggle-message-tray = [ ];
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gtk/settings/file-chooser" = {
        date-format = "regular";
        location-mode = "path-bar";
        show-hidden = false;
        show-size-column = true;
        show-type-column = true;
        sidebar-width = 167;
        sort-column = "name";
        sort-directories-first = false;
        sort-order = "ascending";
        type-format = "category";
        window-position = mkTuple [
          26
          23
        ];
        window-size = mkTuple [
          1231
          902
        ];
      };
    };
  };
}
