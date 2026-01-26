{
  lib,
  config,
  ...
}:
{
  options.mine.server-odoo = {
    enable = lib.mkEnableOption "'server-odoo' role";
  };
  config.mine.server-odoo = lib.mkIf config.mine.server-odoo.enable {
    services = {
      odoo.enable = true;
    };
  };
}
