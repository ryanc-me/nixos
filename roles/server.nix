{
  # a graphical desktop environment with common applications
  mine = {
    apps = {};
    cli = {
      git.enable = true;
      ruff.enable = true;
      step-cli.enable = true;
    };
    desktop = {
      gnome.enable = true;
    };
    services = {
      sshd.enable = true;
    };
    system = {
      boot = {
        systemd.enable = true;
      };
      utils = {
        enable = true;
      };
      users = {
        ryan.enable = true;
      };
    };
  };
}
