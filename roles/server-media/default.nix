{ lib, ... }:
let
  recursiveImportDefault =
    (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  options.mine.server-media = {
    domainBase = lib.mkOption {
      type = lib.types.str;
      description = "Base domain for media server services.";
    };
  };

  config.mine.server-media = {
    domainBase = "mixeto.io";

    services = {
      bazarr.enable = true;
      certs.enable = true;
      lidarr.enable = true;
      nginx.enable = true;
      overseerr.enable = true;
      plex.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
    };
  };
}
