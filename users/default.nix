inputs@{ nixpkgs, home-manager, ... }: let
  lib = nixpkgs.lib;
  files = builtins.readDir ../hosts;
  hosts = lib.filterAttrs (_: type: type == "directory") files;
in lib.concatMapAttrs (hostname: type: let
  host = (import ../hosts/${hostname} inputs).host;
  pkgs = nixpkgs.legacyPackages.${host.arch};
in lib.genAttrs' (host.users) (username: let
  user = (import ./${username} inputs).user;
in lib.nameValuePair "${user.name}@${host.name}" (home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs; inherit host; inherit user; };    
  modules = [ ./modules ./${user.name} ./${user.name}/modules ];
}))) hosts
