{ config, pkgs, ... }:

{
  systemd.user.services = {
    "docker-socket-tunnel@" = {
      Unit = {
        Description = "Docker Socket Tunnel for %i";
        After = [ "network.target" ];
      };
      Service = {
        WorkingDirectory = config.home.homeDirectory;
        ExecStartPre = [ "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.%i.sock" ];
        ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.%i.sock:/var/run/docker.sock %i";
        RestartSec = 5;
        Restart = "always";
      };
    };

    # for now, we'll define these as concrete services
    "docker-socket-tunnel@wedoo-demo.service" = {
      Unit = {
        Description = "Docker Socket Tunnel for %i";
        After = [ "network.target" ];
      };
      Service = {
        WorkingDirectory = config.home.homeDirectory;
        ExecStartPre = [ "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.%i.sock" ];
        ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.%i.sock:/var/run/docker.sock %i";
        RestartSec = 5;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    "docker-socket-tunnel@wedoo-docker1.service" = {
      Unit = {
        Description = "Docker Socket Tunnel for %i";
        After = [ "network.target" ];
      };
      Service = {
        WorkingDirectory = config.home.homeDirectory;
        ExecStartPre = [ "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.%i.sock" ];
        ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.%i.sock:/var/run/docker.sock %i";
        RestartSec = 5;
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  #TODO: auto-enable these?
  # systemctl --user enable --now docker-socket-tunnel@wedoo-demo.service
  # systemctl --user enable --now docker-socket-tunnel@wedoo-docker1.service
}
