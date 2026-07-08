{ config, lib, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      shellAliases.ff = "clear; fastfetch";
    };
  };

  home.packages = with pkgs; [
    fastfetch
    tree
    (writeShellApplication {
      name = "sync-updates";
      text = ''
        pushd "$HOME/.config/home-manager" >/dev/null
        echo $'\033[1;34m'"info:"$'\033[0m'" synchronizing updates from $(jj git remote list 2>/dev/null)";
        jj git fetch
        jj rebase -b @ -d master
        popd >/dev/null
      '';
    })
    (writeShellApplication {
      name = "sync-updates-to-system";
      text = ''
        echo $'\033[1;33m'"warn:"$'\033[0m'" synchronizing updates to /etc/nixos, "$'\033[1m'"sudo"$'\033[0m'" required, commands follow";
        echo "  "$'\033[1m'"sudo"$'\033[0m'" rm -r /etc/nixos/{*,.*}"
        sudo rm -r /etc/nixos/{*,.*}
        echo "  "$'\033[1m'"sudo"$'\033[0m'" cp ~/.config/home-manager/{*,.*} -r /etc/nixos/"
        sudo cp ~/.config/home-manager/{*,.*} -r /etc/nixos/
      '';
    })
  ];
}
