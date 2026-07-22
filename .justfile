default:
    just --list

switch:
    nixos-rebuild switch --flake /home/ryan/nixos#$(hostname) --sudo --ask-sudo-password

boot:
    nixos-rebuild boot --flake /home/ryan/nixos#$(hostname) --sudo --ask-sudo-password

remote machine:
    nixos-rebuild switch --flake /home/ryan/nixos#{{ machine }} --target-host {{ machine }} --sudo --ask-sudo-password

remote-aquime:
    nixos-rebuild switch --flake /home/ryan/nixos#aquime --target-host aquime --sudo --ask-sudo-password

remote-masaq:
    nixos-rebuild switch --flake /home/ryan/nixos#masaq --target-host masaq --sudo --ask-sudo-password

remote-tier:
    nixos-rebuild switch --flake /home/ryan/nixos#tier --target-host tier --sudo --ask-sudo-password

remote-idir:
    nixos-rebuild switch --flake /home/ryan/nixos#idir --target-host idir --sudo --ask-sudo-password

gc:
    sudo nix-collect-garbage -d && nix-collect-garbage -d

optimize:
    nix-store --optimize -v

sops-rotate:
    find secrets/ -type f -exec sops --rotate --in-place {} \;

sops-update:
    find secrets/ -type f -exec sops updatekeys {} \;