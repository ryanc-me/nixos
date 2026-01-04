{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mine.core.enable = lib.mkEnableOption "'core' role";

  config.mine.core = lib.mkIf config.mine.core.enable {
    cli = {
      git.enable = true;
    };
    services = {
      sshd.enable = true;
    };
    system = {
      boot-plymouth.enable = true;
      boot-systemd.enable = true;
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
