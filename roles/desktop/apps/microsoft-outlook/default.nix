{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.microsoft-outlook;
in
{
  options.mine.desktop.apps.microsoft-outlook = {
    enable = mkEnableOption "Microsoft Outlook (email client)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      microsoft-outlook
    ];
  };
}
