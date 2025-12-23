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
    inputs@{ self, nixpkgs, ... }:

    let
      lib = nixpkgs.lib;

      # list of hostnames (directories in ./hosts)
      hostNames = builtins.attrNames (builtins.readDir ./hosts);

      # create a nixosConfiguration from hostName
      # note that `system` and `extraModules` can be specified in
      # hosts/<hostName>/system.nix
      mkHost =
        hostName:
        let
          hostDir = ./hosts/${hostName};
          hostSpecPath = hostDir + "/system.nix";
          hostSpec =
            if builtins.pathExists hostSpecPath then
              (import hostSpecPath { inherit inputs; })
            else
              {
                system = "x86_64-linux";
                extraModules = [ ];
              };

          system = hostSpec.system;

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
          };

        in
        lib.nameValuePair hostName (
          lib.nixosSystem {
            inherit system pkgs;

            specialArgs = {
              inherit inputs self hostName;
            };

            modules = [
              hostDir
              # ./modules/common.nix
            ]
            ++ (hostSpec.extraModules or [ ]);
          }
        );
      nixosConfigurations = lib.listToAttrs (map mkHost hostNames);
    in
    {
      inherit nixosConfigurations;
    };
}
