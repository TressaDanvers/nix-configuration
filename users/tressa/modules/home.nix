{ lib, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      shellAliases.ff = "clear; fastfetch";
    };
  };

  home.packages = with pkgs; [ fastfetch tree ];
}
