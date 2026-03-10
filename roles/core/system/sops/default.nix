{ config, pkgs, ... }:

{
  sops.age.sshKeyPaths = [ "/persist/local/etc/ssh/ssh_host_ed25519_key" ];
}
