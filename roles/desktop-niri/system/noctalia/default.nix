{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.noctalia;
in
{
  options.mine.desktop-niri.system.noctalia = {
    enable = mkEnableOption "noctalia support";
  };

  config = mkIf cfg.enable {
    # services.noctalia-shell.enable = true;
    programs.noctalia-greeter = {
      enable = true;

      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

      greeter-args = "--session=Niri --user=ryan";
      settings.cursor = {
        theme = "\"Capitaine Cursors\"";
        size = 24;
        package = pkgs.capitaine-cursors-themed;
      };
    };
  };
}
