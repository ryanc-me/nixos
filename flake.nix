{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # make Nix copy the `secrets` submodule into the store
    self = {
      submodules = true;
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... } @ inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
  in {
    nixosConfigurations = {
      heibohre = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/heibohre
          {
            my = {
              screenW = 2256;
              screenH = 1504;
              screenScale = 1.5;
              wallpaper = {
                enable = true;
                path = ./wallpapers/wallhaven-wyrqg7.png;
              };
              mode = "centered";
            };
          }

          ./modules/nixos/wallpaper.nix
          ./modules/nixos/gdm-wallpaper.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              ./modules/home-manager/gnome-wallpaper.nix
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ryan = import ./home/ryan.nix;
            home-manager.users.angel = import ./home/angel.nix;
          }
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      idir = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/idir
          {
            my = {
              screenW = 3840;
              screenH = 2160;
              screenScale = 1.5;
              wallpaper = {
                enable = true;
                path = ./wallpapers/wallhaven-wyrqg7.png;
              };
            };
          }

          ./modules/nixos/wallpaper.nix
          ./modules/nixos/gdm-wallpaper.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              ./modules/home-manager/gnome-wallpaper.nix
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ryan = import ./home/ryan.nix;
            home-manager.users.angel = import ./home/angel.nix;
          }
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
  
