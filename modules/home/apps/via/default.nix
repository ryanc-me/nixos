{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.via;
in
{
  options.mine.home.apps.via = {
    enable = mkEnableOption "VIA (keyboard firmware configurator)";
  };

  config = mkIf cfg.enable {
    # NOTE: must load the JSON file (in this folder) to get Nuphy Air75 V2 support
    # 1. open VIA
    # 2. go to Settings tab (gear icon)
    # 3. enable "Show Design tab"
    # 4. go to Design tab (paintbrush icon)
    # 5. load the JSON file

    xdg = {
      enable = true;

      dataFile."icons/hicolor/scalable/apps/via.png".source = ./via.png;
      desktopEntries.via = lib.mkForce {
        name = "VIA";
        comment = "Launch VIA Keyboard Configurator";
        categories = [
          "Utility"
        ];
        icon = "via";
        exec = ''
          ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://usevia.app/" %U
        '';
        settings = {
          StartupWMClass = "usevia.app";
        };
      };
    };
  };
}
