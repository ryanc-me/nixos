# modules/nixos/gdm-wallpaper.nix
{ lib, pkgs, config, ... }:
let
  wp = config.my.wallpaper.processedPath;
  enable = config.my.wallpaper.enable;
  gdmCssOverlay = pkgs.runCommand "gdm-css-overlay" { buildInputs = [ pkgs.glib ]; } ''
    set -eu
    mkdir -p "$out/share/gnome-shell/theme"
    src_res="${pkgs.gnome-shell}/share/gnome-shell/gnome-shell-theme.gresource"

    for f in /org/gnome/shell/theme/gnome-shell-light.css \
            /org/gnome/shell/theme/gnome-shell-dark.css \
            /org/gnome/shell/theme/gnome-shell-high-contrast.css; do
      if gresource list "$src_res" | grep -q "$f"; then
        dst="$out/share/gnome-shell/theme/$(basename "$f")"
        gresource extract "$src_res" "$f" > "$dst"
        cat >> "$dst" <<EOF

  /* injected by overlay */
  stage, #screenShieldGroup, #lockDialogGroup, .login-dialog, .unlock-dialog {
    background: url("file://${wp}/share/wallpapers/greeter-wallpaper.jpg") no-repeat center center fixed !important;
    background-size: auto !important;   /* centered, not stretched */
    background-color: black !important; /* fill around edges */
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
  };
}