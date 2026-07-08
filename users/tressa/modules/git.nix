{ config, user, lib, pkgs, ... }: {
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Tressa Danvers";
          email = "TDanvers@protonmail.ch";
        };
        ui.default-command = "log";
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Tressa Danvers";
          email = "TDanvers@protonmail.ch";
        };
      };
    };

    gh.enable = true;
  };

  sops.secrets.ghtoken = {};
  sops.templates.gh = {
    path = "${config.home.homeDirectory}/.config/gh/hosts.yml";
    mode = "0600";
    content = builtins.replaceStrings
      [ "@GH_TOKEN@" ]
      [ config.sops.placeholder.ghtoken ]
      (builtins.readFile ../config/gh/hosts.yml);
  };
}
