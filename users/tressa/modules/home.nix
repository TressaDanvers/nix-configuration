{ inputs, lib, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ff = "clear; fastfetch";
        of = "clear; onefetch";
      };
    };
  };

  home = {
    packages = with pkgs; [
      tree

      fastfetch
      onefetch

      obsidian
    ];
  };
}
