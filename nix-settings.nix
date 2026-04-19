{ ... }:
{
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  nixpkgs.config = {
    # 1password, sublime4, etc
    allowUnfree = true;

    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
}
