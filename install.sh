#!/usr/bin/env bash
git clone https://github.com/TressaDanvers/nix-configuration ~/.config/home-manager
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
nix run nixpkgs#home-manager -- switch

pushd ~/.config/home-manager
jj git init
jj bookmark track master --remote origin
popd
