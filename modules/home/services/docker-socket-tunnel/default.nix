{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.services.docker-socket-tunnel;
in
{
  options.mine.home.services.docker-socket-tunnel = {
    enable = mkEnableOption "docker socket forwarding (wedoo-xx)";
  };

  # for some reason, $DISPLAY is not set when xdg-desktop-portal launches, which
  # prevents firefox from auto-launching when the `step ssh login` is fired. to
  # fix:
  #
  # systemctl --user restart xdg-desktop-portal

  config = mkIf cfg.enable {
    systemd.user.services = {
      # for now, we'll define these as concrete services
      "docker-socket-tunnel:wedoo-demo" = {
        Unit = {
          Description = "Docker Socket Tunnel for %i";
          After = [ "network.target" ];
        };
        Service = {
          WorkingDirectory = config.home.homeDirectory;
          ExecStartPre = [
            "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.wedoo-demo.sock"
          ];
          ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.wedoo-demo.sock:/var/run/docker.sock wedoo-demo";
          RestartSec = 5;
          Restart = "always";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      "docker-socket-tunnel:wedoo-docker1" = {
        Unit = {
          Description = "Docker Socket Tunnel for wedoo-docker1";
          After = [ "network.target" ];
        };
        Service = {
          WorkingDirectory = config.home.homeDirectory;
          ExecStartPre = [
            "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.wedoo-docker1.sock"
          ];
          ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.wedoo-docker1.sock:/var/run/docker.sock wedoo-docker1";
          RestartSec = 5;
          Restart = "always";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      "docker-socket-tunnel:wedoo-dev" = {
        Unit = {
          Description = "Docker Socket Tunnel for wedoo-dev";
          After = [ "network.target" ];
        };
        Service = {
          WorkingDirectory = config.home.homeDirectory;
          ExecStartPre = [
            "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.wedoo-dev.sock"
          ];
          ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.wedoo-dev.sock:/var/run/docker.sock wedoo-dev";
          RestartSec = 5;
          Restart = "always";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };

    #TODO: get this working
    #
    # the service itself is okay, but I can't figure out how to enable the service
    # via nix

    # "docker-socket-tunnel@" = {
    #   Unit = {
    #     Description = "Docker Socket Tunnel for %i";
    #     After = [ "network.target" ];
    #   };
    #   Service = {
    #     WorkingDirectory = config.home.homeDirectory;
    #     ExecStartPre = [ "${pkgs.coreutils}/bin/rm -f ${config.home.homeDirectory}/.docker.%i.sock" ];
    #     ExecStart = "${pkgs.openssh}/bin/ssh -NT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L ${config.home.homeDirectory}/.docker.%i.sock:/var/run/docker.sock %i";
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    # systemctl --user enable --now docker-socket-tunnel@wedoo-demo.service
    # systemctl --user enable --now docker-socket-tunnel@wedoo-docker1.service
    # systemctl --user enable --now docker-socket-tunnel@wedoo-dev.service
  };
}
