{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    probe-rs-rules = {
      url = "github:jneem/probe-rs-rules";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    self = {
      # make Nix copy the `secrets` submodule into the store
      submodules = true;
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;

      # find entries in hosts/ which have a default.nix (e.g., hosts/blah/default.nix)
      listSubdirsWithDefault =
        (import ./lib/listSubdirsWithDefault.nix { inherit lib; }).listSubdirsWithDefault;
      hosts = listSubdirsWithDefault ./hosts;

      forEachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            localSystem = { inherit system; };

            # for microsoft-edge
            config.allowUnfree = true;
          };
        in
        {
          ghost-cms = pkgs.callPackage ./packages/ghost-cms/default.nix { };
          habitsync = pkgs.callPackage ./packages/habitsync/default.nix { };
          microsoft-outlook = pkgs.callPackage ./packages/microsoft-outlook/default.nix { };
          microsoft-teams = pkgs.callPackage ./packages/microsoft-teams/default.nix { };
          odoo = pkgs.callPackage ./packages/odoo/default.nix { };
          spotify = pkgs.callPackage ./packages/spotify/default.nix { };
          toggl-track = pkgs.callPackage ./packages/toggl-track/default.nix { };
          via = pkgs.callPackage ./packages/via/default.nix { };
        }
      );

      nixosConfigurations = builtins.listToAttrs (
        map (
          hostname:
          let
            system = import ./hosts/${hostname}/system.nix;
          in
          {
            # build a nixosSystem for each host
            name = hostname;
            value = lib.nixosSystem {
              # the rest of this is just like any other flake
              specialArgs = {
                inherit inputs self hostname;
              };
              system = system;
              modules = [
                # the host will import any roles it needs
                ./hosts/${hostname}

                # shared modules
                inputs.sops-nix.nixosModules.sops
                inputs.impermanence.nixosModules.impermanence
                inputs.home-manager.nixosModules.home-manager
                inputs.vscode-server.nixosModules.default
                inputs.probe-rs-rules.nixosModules.${system}.default

                # home-manager configuration
                (
                  { config, lib, ... }:
                  let
                    availableUsers = [
                      "ryan"
                      "angel"
                    ];
                    enabledUsers = map (user: user) (
                      lib.filter (u: config.mine.users.${u}.enable == true) availableUsers
                    );
                  in
                  {
                    home-manager = lib.mkIf config.mine.core.system.home-manager.enable {
                      sharedModules = [
                        # load all modules in ./roles/home, then the users/<user>/default.nix
                        # will selectively enable what it needs
                        ./home

                        # and again, shared modules
                        inputs.sops-nix.homeManagerModules.sops
                        inputs.flatpaks.homeModules.default
                      ];

                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = {
                        inherit inputs self hostname;
                      };

                      # we semi-dynamiclly generate the `users attrset, depending on
                      # what the host asks for
                      users = builtins.listToAttrs (
                        map (user: {
                          name = user;
                          value = ./users/${user};
                        }) enabledUsers
                      );
                    };
                  }
                )
              ];
            };
          }
        ) hosts
      );
    };
}
