{ lib, ... }:
let

  inherit (lib)
    collect
    concatStringsSep
    isString
    mapAttrsRecursive
    mapAttrs;
  
  inherit (builtins)
    readDir
    baseNameOf
    filter;

  # Credit: @infinisil
  # https://github.com/Infinisil/system/blob/df9232c4b6cec57874e531c350157c37863b91a0/config/new-modules/default.nix

  getDir = dir: mapAttrs
    (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
    (readDir dir);

  files = dir: collect isString
    (mapAttrsRecursive
      (path: type: concatStringsSep "/" path)
      (getDir dir)
    );

  recursiveImportDefault =
    dir:
    map
      (file: dir + "/${file}")
      (filter
        (file: baseNameOf file == "default.nix" && toString file != "default.nix")
        (files dir)
    );

in
{
  recursiveImportDefault = recursiveImportDefault;
}
