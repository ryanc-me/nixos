{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.microsoft-outlook;
in
{
  options.mine.home.apps.microsoft-outlook = {
    enable = mkEnableOption "Enable Microsoft Outlook (email client)";
  };

  config = mkIf cfg.enable {
    #TODO: this
    #assert (osConfig.mine.nixos.apps.microsoft-edge = true): "Cannot enable (home) microsoft-outlook if (nixos) microsoft-edge is not active"

    xdg = {
      enable = true;

      dataFile."icons/hicolor/scalable/apps/microsoft-outlook.svg".source = ./microsoft-outlook.svg;
      desktopEntries.microsoft-outlook = lib.mkForce {
        name = "Outlook";
        comment = "Launch Microsoft Outlook";
        categories = [
          "Network"
          "Email"
        ];
        icon = "microsoft-outlook";
        exec = ''
          ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://outlook.office.com/mail/" %U
        '';
        settings = {
          StartupWMClass = "msedge-outlook.office.com__mail_-Default";
        };
      };
    };
  };
}
