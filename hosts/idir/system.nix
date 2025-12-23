{ inputs, ... }:

{
  system = "x86_64-linux";
  extraModules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.gigabyte-b550
    {
      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.flatpaks.homeModules.default
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ryan = import ./../../users/ryan;
      home-manager.users.angel = import ./../../users/angel;
    }
  ];
}
