{
  lib,
  config,
  ...
}:
{
  options.mine.users.enable = lib.mkEnableOption "'users' role";

  config.mine.users = lib.mkIf config.mine.users.enable {
    ryan.enable = lib.mkDefault true;
    angel.enable = lib.mkDefault false;
  };
}
