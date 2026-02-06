{
  description = "Noctalia shell - a Wayland desktop shell built with Quickshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      packages.${system}.default = pkgs.callPackage ./default.nix { };

      # Optional: a dev shell for interactive debugging (`nix develop`)
      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];
      };
    };
}
