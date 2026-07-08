{ lib, ... }: let
  files = builtins.readDir ./.;
  modules = lib.filterAttrs (name: type: (type == "regular" && name != "default.nix") || type == "directory") files;
in { imports = map (name: ./${name}) (builtins.attrNames modules); }
