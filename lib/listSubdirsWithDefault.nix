{ lib, ... }:
let
  listSubdirsWithDefault =
    targetDir:
    let
      entries = builtins.readDir targetDir;
      subdirs = builtins.attrNames entries;
      hasDefault = name: builtins.pathExists (targetDir + "/${name}/default.nix");
    in
    builtins.filter hasDefault subdirs;
in
{
  listSubdirsWithDefault = listSubdirsWithDefault;
}
