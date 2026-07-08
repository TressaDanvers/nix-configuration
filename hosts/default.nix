inputs@{ nixpkgs, ... }: let
  lib = nixpkgs.lib;
  files = builtins.readDir ./.;
  hosts = lib.filterAttrs (_: type: type == "directory") files;
in lib.mapAttrs (name: type: let
  host = (import ./${name} inputs).host;
in lib.nixosSystem {
  system = host.arch;
  specialArgs = { inherit inputs; inherit host; };
  modules = [ ../modules ./${host.name} ./${host.name}/modules ];
}) hosts
