{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.services.flatpak;
in
{
  options.mine.desktop.services.flatpak = {
    enable = mkEnableOption "Flatpak support";
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
    };

    # also add flathub repo (not included by default?)
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
