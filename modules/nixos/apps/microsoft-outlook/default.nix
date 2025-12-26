{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.microsoft-outlook;
in
{
  options.mine.nixos.apps.microsoft-outlook = {
    enable = mkEnableOption "Enable Microsoft Outlook (email client)";
  };

  config = mkIf cfg.enable {
    #TODO: move to modules/home/
    # # just below direct-setting, but above mkForce to allow user override
    # mine.nixos.apps.microsoft-outlook.enable = lib.mkOverride 90 true;

    # xdg = {
    #   enable = true;

    #   dataFile."icons/hicolor/scalable/apps/microsoft-outlook.svg".source = ./microsoft-outlook.svg;
    #   desktopEntries.microsoft-outlook = lib.mkForce {
    #     name = "Outlook";
    #     comment = "Launch Microsoft Outlook";
    #     categories = [
    #       "Network"
    #       "Email"
    #     ];
    #     icon = "microsoft-outlook";
    #     exec = ''
    #       ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://outlook.office.com/mail/" %U
    #     '';
    #     settings = {
    #       StartupWMClass = "msedge-outlook.office.com__mail_-Default";
    #     };
    #   };
    # };
  };
}
