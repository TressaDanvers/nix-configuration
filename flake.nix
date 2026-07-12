{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    preservation.url = "github:nix-community/preservation";
    sops-nix.url = "github:mic92/sops-nix";

    home-manager.url = "github:nix-community/home-manager";
    nixcord.url = "github:4evy/nixcord";

    ge-proton-flake.url = "github:TressaDanvers/ge-proton-flake";
    tamper-scripts.url = "github:TressaDanvers/tamper-scripts";

    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    tamper-scripts.flake = false;
  };

  outputs = inputs: {
    nixosConfigurations = (import ./hosts inputs);
    homeConfigurations = (import ./users inputs);
  };
}
