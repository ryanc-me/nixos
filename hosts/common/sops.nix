{ config, pkgs, ... }:

{
  sops.age.keyFile = "/home/ryan/.config/sops/age/keys.txt";
}
