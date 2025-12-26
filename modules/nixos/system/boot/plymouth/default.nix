{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.system.boot.plymouth;
in
{
  options.mine.nixos.system.boot.plymouth = {
    enable = mkEnableOption "Enable Plymouth boot splash screen with mac-style theme";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-style-plymouth.overlays.default ];
    environment.systemPackages = with pkgs; [
      hack-font
      nixos-icons
    ];
    boot = {
      plymouth = {
        enable = true;
        theme = "mac-style";
        themePackages = [ pkgs.mac-style-plymouth ];
        extraConfig = ''
          DeviceScale=2
        '';
      };

      plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";

      consoleLogLevel = 3;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      loader.timeout = 0;
    };
  };
}
