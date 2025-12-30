{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.system.kernel;
in
{
  options.mine.core.system.kernel = {
    package = mkOption {
      type = lib.types.attrs;
      description = "The kernel package to use.";
    };
  };

  # no enable option here!
  config.boot.kernelPackages = cfg.package;
}
