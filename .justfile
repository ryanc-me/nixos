default:
    just --list

switch:
    nixos-rebuild switch --flake /home/ryan/nixos#$(hostname) --sudo --ask-sudo-password

remote machine:
    nixos-rebuild switch --flake /home/ryan/nixos#{{ machine }} --target-host {{ machine }} --sudo --ask-sudo-password

gc:
    sudo nix-collect-garbage -d && nix-collect-garbage -d

optimize:
    nix-store --optimize -v

sops-rotate:
    find secrets/ -type f -exec sops --rotate --in-place {} \;

sops-update:
    find secrets/ -type f -exec sops updatekeys {} \;