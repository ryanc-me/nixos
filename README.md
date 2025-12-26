# NixOS Configuration

Welcome to my NixOS configuration!

As some context: This configuration is used across a few of my devices - a work PC,
laptop, and (eventually) a home server I have sitting in a closet. The goal is for
this config to be rock-solid, and especially, keep my PC/laptop configured as
similarly as possible.

## Features

 - Uses Nix Flakes for reproducible builds
 - Home Manager for user-specific config
 - Gnome + Forge for the desktop environment
 - Configures Gnome/etc via dconf
 - Non-Linux-native apps via progressive webapps (Teams, etc)
 - Syncthing to keep data in sync across devices
 - Secrets via `sops-nix`, stored in a private submodule for extra privacy
 - Using Impermanence, 


## Guiding

## Bootstrapping

**TODO**

## Inspiration

These repos provided some excellent inspiration for me:

 * [**Misterio77**'s nix-config repo](https://github.com/Misterio77/nix-config/tree/main)
 * [**mitchellh**'s nixos-config repo](https://github.com/mitchellh/nixos-config)
 * [**thursdaddy**'s nixos-config repo](https://github.com/thursdaddy/nixos-config)