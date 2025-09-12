# modules/nixos/gdm-wallpaper.nix
{ lib, pkgs, config, ... }:
let
  wp = config.my.wallpaper.processed.blurred;
  enable = config.my.wallpaper.enable;
  gdmCssOverlay = pkgs.runCommand "gdm-css-overlay"
    { buildInputs = [ pkgs.glib pkgs.imagemagick ]; }
    ''
      set -euo pipefail
      mkdir -p "$out/share/gnome-shell/theme"
      src_res="${pkgs.gnome-shell}/share/gnome-shell/gnome-shell-theme.gresource"

      theme_files=(
        /org/gnome/shell/theme/gnome-shell-light.css
        /org/gnome/shell/theme/gnome-shell-dark.css
        /org/gnome/shell/theme/gnome-shell-high-contrast.css
      )
      
      for f in ''${theme_files[*]}; do
        if gresource list "$src_res" | grep -q "$f"; then
          dst="$out/share/gnome-shell/theme/$(basename "$f")"
          gresource extract "$src_res" "$f" > "$dst"
          cat >> "$dst" <<EOF

/* injected by overlay */
#lockDialogGroup {
  background-image: url("file://${wp}/share/wallpapers/blurred.png") !important;
  background-repeat: no-repeat !important;
  background-position: center center !important;
}

EOF
        fi
      done
    '';
in
{
  config = lib.mkIf enable {
    # Make the overlay visible to GDM’s gnome-shell (via PAM /etc/environment.d)
    environment.etc."environment.d/90-gdm-gresource.conf".text =
      "G_RESOURCE_OVERLAYS=/org/gnome/shell/theme=${gdmCssOverlay}/share/gnome-shell/theme\n";

    # make GDM better align with the desktop layout
    programs.dconf.profiles.gdm.databases = [{
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-light";
          gtk-theme = "Adwaita-Light";
          clock-format = "12h";
        };
      };
    }];
  };
}