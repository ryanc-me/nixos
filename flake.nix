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

      # get a list of names of subdirs that contain a default.nix
      listSubdirsWithDefault =
        targetDir:
        let
          entries = builtins.readDir targetDir;
          subdirs = builtins.attrNames entries;
          hasDefault = name: builtins.pathExists (targetDir + "/${name}/default.nix");
        in
        builtins.filter hasDefault subdirs;

      # filter enabled users

      # list users and hosts
      users = listSubdirsWithDefault ./users;
      hosts = listSubdirsWithDefault ./hosts;
    in
    {
      # dynamically import hosts from ./hosts/<hostname>/default.nix
      #
      # every hosts get
      # - some basic modules (/home/nixos/**/default.nix)
      # - sops, impermanence, home-manager
      # - hm config for users in ./users (also dynamically imported)
      #
      # we pass `inputs` to so that from the hosts' default.nix, we
      # can `import [ inputs.blah ]` (e.g., for nixos-hardware)
      #
      # finally note that while all flake inputs are added to `modules`
      # here, they generally will not be enabled unless explicitly
      # configured via `mine.nixos.xx`.

      nixosConfigurations = builtins.listToAttrs (
        map (hostname: {
          name = hostname;
          value = lib.nixosSystem {
            specialArgs = {
              inherit inputs self hostname;
            };
            # system = "x86_64-linux";
            modules = [
              # the host config itself
              ./hosts/${hostname}

              # other nixos modules
              ./modules/nixos/import.nix

              # general flake imports
              inputs.sops-nix.nixosModules.sops
              inputs.impermanence.nixosModules.impermanence
              inputs.home-manager.nixosModules.home-manager

              # home-manager configuration
              (
                { config, lib, ... }:
                let
                  # allow hosts to specify whether hm is enabled, and if some
                  # users should be (in)active
                  cfg = config.mine.nixos.system.home-manager;

                  # error if both activeUsers *and* disabledUsers are set
                  _ =
                    if cfg.enabledUsers != [ ] && cfg.disabledUsers != [ ] then
                      lib.throwError "mine.nixos.system.home-manager: cannot set both enabledUsers and disabledUsers"
                    else
                      null;

                  activeUsers =
                    if cfg.enabledUsers == [ ] then
                      # enable all users
                      users
                    else if cfg.disabledUsers != [ ] then
                      # enable all except disabled
                      lib.filter (u: !(lib.elem u cfg.disabledUsers)) users
                    else
                      # intersect with configured list
                      lib.intersectLists users cfg.enabledUsers;

                in
                {
                  # nixos.nix does anything that we can't do via hm (e.g., set passwords)
                  imports = [
                    ./users/ryan/nixos.nix
                    ./users/angel/nixos.nix
                  ];

                  # unfortunately this doesn't work due to infinite recursion:
                  # imports = map (user: ./users/${user}/nixos.nix) activeUsers;

                  home-manager = lib.mkIf cfg.enable {
                    sharedModules = [
                      ./modules/home/import.nix
                      inputs.sops-nix.homeManagerModules.sops
                      inputs.flatpaks.homeModules.default
                    ];
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                      inherit inputs self hostname;
                    };
                    users = builtins.listToAttrs (
                      map (user: {
                        name = user;
                        value = ./users/${user};
                      }) activeUsers
                    );
                  };
                }
              )
            ];
          };
        }) hosts
      );
    };
}
