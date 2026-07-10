{
  description = "GE-Proton deployment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      version = "11-1";
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "ge-proton";
        inherit version;

        src = builtins.fetchTarball {
          url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
          sha256 = "sha256:0z1sr1dv6bhxbwr7b05b5x6iml0n0p92gs88pyfxmz0h6jzr5d13";
        };

        phases = [ "unpackPhase" "installPhase" ];

        installPhase = ''
          mkdir $out
          cp -r * $out/
        '';
      };
    }
  );
}
