#!/usr/bin/env bash
git clone https://github.com/TressaDanvers/nix-configuration ~/.config/home-manager
nix run --extra-experimental-features 'nix-command flakes' nixpkgs#home-manager switch --extra-experimental-features 'nix-command flakes'
