{ lib, pkgs, ... }:
let
  recursiveImportDefault =
    (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  config.mine.core = {
    cli = {
      git.enable = true;
    };
    services = {
      sshd.enable = true;
    };
    system = {
      home-manager.enable = true;
      hostname.enable = true;
      impermanence.enable = true;
      kernel.package = lib.mkDefault pkgs.linuxPackages_latest;
      network-manager.enable = true;
      timezone.enable = true;
      utils = {
        enable = true;

        # everything enabled by default
        cli-utils = true;
        text-editors = true;
        archiving-compression = true;
        nix-utils = true;
        network-utils = true;
        system-monitoring = true;
        other-utils = true;
        system-tools = true;
      };
    };
  };
}
