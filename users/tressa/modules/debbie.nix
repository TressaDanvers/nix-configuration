{ lib, host, config, ... }: {
  config = lib.optionalAttrs (host.name == "debbie") {
    xdg.desktopEntries = {
      votv = {
        name = "Voices of the Void";
        exec = "gamescope -W 1920 -H 1080 ${config.home.homeDirectory}/.local/opt/votv/VotV.exe";
        icon = ../resources/icons/VotV.ico;
        type = "Application";
        terminal = false;
        categories = [ "Game" ];
      };
    };
  };
}
