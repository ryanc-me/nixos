{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.codex-desktop;
  codexCli = inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.mine.desktop.apps.codex-desktop = {
    enable = mkEnableOption "Codex Desktop (Linux client for Codex, the AI assistant)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      codexCli
    ];
    programs.codexDesktopLinux = {
      enable = true;
      cliPackage = codexCli;
    };
  };
}
