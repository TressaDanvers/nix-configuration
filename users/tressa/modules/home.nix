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

      moonlight-qt
      (writeShellApplication { name = "harmony"; text = "exec ${pkgs.moonlight-qt}/bin/moonlight stream harmony desktop --display-mode borderless"; })

      obsidian
    ];
  };

  xdg.desktopEntries.windows = {
    name = "Microsoft Windows";
    exec = "harmony";
    icon = ../resources/icons/Windows.png;
    terminal = false;
    categories = [ "System" ];
  };
}
