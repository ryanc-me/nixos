# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export EDITOR="nano"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin"
      export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR}/ssh-agent"
      export TERM="xterm-256color"

      # if [[ $(tty) == *"pts"* ]]; then
      #   fastfetch
      # fi
    '';

    shellAliases = {
      l = "eza -lb --icons auto";
      ll = "eza -lab --icons auto";
      lt = "eza -lab -TRL1 --icons auto --total-size";
      lt2 = "eza -lab -TRL2 --icons auto --total-size";
      lt3 = "eza -lab -TRL3 --icons auto --total-size";
      lt4 = "eza -lab -TRL4 --icons auto --total-size";
      c = "clear";
    };
  };
}
