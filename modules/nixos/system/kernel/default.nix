{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.system.kernel;
in
{
  options.mine.system.kernel = {
    package = mkOption {
      type = lib.types.attrs;
      default = pkgs.linuxPackages_latest;
      description = "The kernel package to use.";
    };
  };

  # no enable option here!
  config.boot.kernelPackages = cfg.package;
}
