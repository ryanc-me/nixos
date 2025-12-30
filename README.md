# NixOS Configuration

Welcome to my NixOS configuration!

This config currently powers a few devices (home desktop, work laptop), but I have plans to bring several other devices in too: my home media server, Home Assistant server, router, etc.

The goal is to have an ultra-comfortable environment across all of my devices.


## Features

 - ❄️ Nix Flakes for reproducable builds via version-locking
 - 🏠 Home Manager for user environment/config management (e.g., envvars, dbus config, etc)
 - ↔️ Syncthing to mirror *data* across devices (e.g., latop/desktop/server)
 - 🔐 Secrets via `sops-nix` - user passwords, SSH keys, etc
 - 🔨 Non Linux-native apps via browser/PWA (Teams, Outlook, etc)
 - 🖥️ Gnome + Forge for a clean desktop experience

## How does it work?

**Note**: This repo is still very much a work-in-progress, so the below description might not align with the setup 100%.

### Everything is a module

This config borrows heavily from [thursdaddy/nixos-config](https://github.com/thursdaddy/nixos-config). In his config, (almost) every `.nix` file is a module, with an explicit `enable` attribute. For example, to enable FreeCAD , I would set `mine.nixos.apps.freecad.enable = true;`. That option namespace follows the folder structure. Something similar is done on the Home Manager side.

This is effectively an abstraction over the default NixOS/nixpkgs options, specific for my use cases.

It may seem overly-verbose, but it gives me the flexibiltiy to turn off whole "features" with one option. For example, my Steam module bundles some other apps (gamescope, proton GE, etc) which are not enabled by the standard `programs.steam.enable` option.

### Role-based structure

This NixOS config is a bit unique, because it's used across many different types of device:
 * Desktops & Laptops, where we need a DE, lots of applications, GPU drivers, etc
 * Servers, where we want a headless environment, and more open firewall rules
 * Router, where we want a very specific set of packages and configs, to reduce attack surface

To accomodate this, the whole config tree has been broken into "roles" (see `roles/`).

The idea is, each role covers one set of features that we may want to enable/disable together. For example, GNOME is bundled into the `desktop-gnome` role, which includes the DE itself, `GDM`, wallpaper management, extensions, and some logic for the `monitors.xml` file. Hopefully you can imagine that to enable another DE (e.g., hyprland), we might create another role call `desktop-hyprland` which would handle all of the specifics.

There is a special `core` role which should be included for all hosts. It handles things like basic CLI tools (`curl`, `tar`, `nano`, etc).

Finally, each role has a root `default.nix` (e.g., `core/default.nix`) which serves two purposes:
 1. It recursively loads all `default.nix` files within the roles' folder (auto-import)
 2. It sets default option values for all of the modules in that role

For example, the `core` role has a `kernel` module which exposes an option `mine.core.system.kernel.package` to help configure a kernel to be installed. The `core/default.nix` then sets a *default* value for that option. So, when a host opts-in to the `core` role, that host will get a default kernel (but will have the option to override it if desired).

### Host-specific config

Each host has an entry in the `hosts/` folder.

Generally, the configuration is very light. It might contain:
 1. The `system.stateVersion`
 2. Any hardware-related imports
 3. A list of `roles/xxx` imports
 4. A small `mine = {}` config snippet for host-specific options

So, when it comes to deciding which functionality is available on a host, we primarily use the *roles import*. For example, my desktop imports (among others) `roles/desktop`, `roles/desktop-gnome`, `roles/desktop-gaming` - this means that I get a GNOME-based setup, with some gaming features enabled.

Finally, a small set of host-specific options are added under the `mine.xxx` namespace. This is generally a very short list, perhaps only configuration for the monitor size (which is really just used for wallpaper processing).

The end result is: A very small host config (~40-50 lines), maximum shared config, and good control over which features are enabled/disabled.

Finally, hosts are dynamically loaded; Any folder in `hosts/`, which has a `default.nix` under it, will be imported automatically.

### Home Manager

The HM config is split into two parts:

 * `home/`: Contains a list of modules which can then be enabled by users. This is for config that might be shared between users (e.g., my personal envvars would *not* live here)
 * `users/<user>/`: Contains all of the user-specific config, and options to enable modules from `home/`

With this setup, I can share some config with other users on my desktop/laptop (e.g., Wayland/Ozone envvars), while keeping my personal config separate.

## Layout

 - `asssets/`: For any static non-Nix files (e.g., wallpapers). Generally config files are store in the module which uses them (i.e., not here).
 - `roles/`: A list of roles, optionally following the structure below
    - `modules/example/apps`: Desktop applications
    - `modules/example/cli`: CLI tools
    - `modules/example/desktop`: Anything relating to a DE
    - `modules/example/services`: Background services
    - `modules/example/system`: System-wide options (also a bit of an "etc")
 - `home/`: shared HM config
 - `hosts/`: List of hosts
 - `users/`: List of users

## Inspiration

These repos provided some excellent inspiration for me:

 * [**Misterio77**'s nix-config repo](https://github.com/Misterio77/nix-config/tree/main)
 * [**mitchellh**'s nixos-config repo](https://github.com/mitchellh/nixos-config)
 * [**thursdaddy**'s nixos-config repo](https://github.com/thursdaddy/nixos-config)