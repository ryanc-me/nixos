{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks = {
      url = "github:in-a-dil-emma/declarative-flatpak/latest";
    };

    # make Nix copy the `secrets` submodule into the store
    self = {
      submodules = true;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      impermanence,
      nixos-hardware,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      nixosConfigurations = {
        heibohre = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/heibohre
            sops-nix.nixosModules.sops
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            {
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.flatpaks.homeModules.default
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ryan = import ./users/ryan;
              home-manager.users.angel = import ./users/angel;
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
            sops-nix.nixosModules.sops
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.gigabyte-b550
            {
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.flatpaks.homeModules.default
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ryan = import ./users/ryan;
              home-manager.users.angel = import ./users/angel;
            }
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        aquime = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/aquime
            sops-nix.nixosModules.sops
            impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
            {
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.flatpaks.homeModules.default
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ryan = import ./users/ryan;
              home-manager.users.angel = import ./users/angel;
            }
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
