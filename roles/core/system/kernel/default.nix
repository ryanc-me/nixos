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
      type = lib.types.raw;
      default = pkgs.linuxPackages;
      description = "The kernel package to use.";
      example = lib.literalExpression "pkgs.linuxPackages_latest";
    };
  };

  # no enable option here!
  config.boot.kernelPackages = cfg.package;
}
