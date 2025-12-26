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

### Everything is a module

This config borrows heavily from [thursdaddy/nixos-config](https://github.com/thursdaddy/nixos-config). In his config, (almost) every `.nix` file is a module, with an explicit `enable` attribute. For example, to enable FreeCAD , I would set `mine.nixos.apps.freecad.enable = true;`. That option namespace follows the folder structure. Something similar is done on the Home Manager side: Enabling Spotify requires a `mine.home.apps.spotify.enable = true;`.

This is effectively an abstraction over the default NixOS/nixpkgs options, specific for my use cases.

It may seem overly-verbose, but it gives me the flexibiltiy to turn off whole "features" with one option. For example, my Steam module bundles some other apps (gamescope, proton GE, etc) which are not enabled by the standard `programs.steam.enable` option.

### NixOS config via `roles/`

Under the `roles/` directory, is a set of files containing plain Nix expressions. Each file is a "role", whose expression tells us which modules should be enabled. For example, the `desktop.nix` role contains all of the  options I'd like to enable for my desktop-type devices (work PC, gaming PC, laptop).

Then, my two desktop-type devices (`idir` and `aquime`) can simply include that role to get all of the relevant apps, services, Gnome configs, etc.

As a result, the device-specific config (under `hosts/<device>/default.nix`) simply needs to specify options that are specific to that device: Screen size, nixos-hardware modules, GPU support, etc.

### Home Manager config via `users/`

Finally, the HM config follows a very similar setup: Modules under `modules/home/` expose options that are then set via `users/<user>/default.nix`. So, each user gets exactly the setup they need, and that setup can be shared across users if necessary.

Note that the `users/<user>/` folder also contains a `nixos.nix`. This file is responsible for configuring the user groups, password, etc - anything that would require root privileges. It's able to do this, because this module is actually incldued from the NixOS side, *not* from HM. The `nixos.nix` file lives under `users/<user>/` purely for convenience.

### Auto-load hosts and users

Hosts and users are loaded automatically - See the `flake.nix` for more info.

*Note*: Users technically need to be specified in the `flake.nix`, but I'm hoping that will be solveable in the future (see `flake.nix`, line ~119).

### Result

This setup has a few nice benefits

 1. When adding a new module, I only need to "enable" it in a few places under `roles/`, rather than duplicating `mine.nixos.apps.someapp = true;` across several host configs
 2. New hosts immediately get a good "sensible" default. From there, extra things can be enabled/disabled as necessary. See `hosts/aquime/default.nix` and `hosts/idir/default.nix` for an example - those files are only ~30 lines long!
 3. It's easy to see exactly what's been "customised" for a particular host
 4. It's easy to enable/disable features for a specific host (e.g., if there's some incompatibility)

## Layout

 - `asssets/`: For any static non-Nix files (e.g., wallpapers). Generally config files are store in the module which uses them (i.e., not here).
 - `modules/`
    - `modules/nixos/`:
        - `modules/nixos/apps`: Desktop applications
        - `modules/nixos/cli`: CLI tools
        - `modules/nixos/desktop`: Anything relating to a DE
        - `modules/nixos/services`: Background services
        - `modules/nixos/system`: System-wide options (also a bit of an "etc")
    - `modules/home/`: Home Manager modules
        - `modules/home/apps`: Desktop applications
        - `modules/home/desktop`: Anything relating to a DE
        - `modules/home/env`: Environment and confiuguration
        - `modules/home/services`: Background services
        - `modules/home/system`: System-wide options (also a bit of an "etc")
 - `hosts/`: A folder specific to each host - see above
 - `users/`: A folder specific to each user - see above
 - `roles/`: Common "roles" used across hosts - see above

## Inspiration

These repos provided some excellent inspiration for me:

 * [**Misterio77**'s nix-config repo](https://github.com/Misterio77/nix-config/tree/main)
 * [**mitchellh**'s nixos-config repo](https://github.com/mitchellh/nixos-config)
 * [**thursdaddy**'s nixos-config repo](https://github.com/thursdaddy/nixos-config)