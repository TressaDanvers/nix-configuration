{ config, lib, pkgs, ... }: {
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ff = "clear; fastfetch";
        deploy-nixos-configuration = ''\
          echo 'sudo rm -r /etc/nixos/{*,.*}';\
          sudo rm -r /etc/nixos/{*,.*};\
          echo 'sudo cp -r ~/.config/home-manager/{*,.*} /etc/nixos/';\
          sudo cp ~/.config/home-manager/{*,.*} -r /etc/nixos/;\
        '';
      };
    };
  };

  home.packages = with pkgs; [ fastfetch tree ];
}
