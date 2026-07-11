{ lib, host, config, ... }: {
  config = lib.optionalAttrs (host.name == "debbie") {
    xdg.desktopEntries = {
      votv = {
        name = "Voices of the Void";
        exec = "${config.home.homeDirectory}/.local/opt/votv/VotV.exe";
        icon = "${config.home.homeDirectory}/.local/opt/votv/VotV.ico";
        type = "Application";
        terminal = false;
        categories = [ "Game" ];
      };
    };
  };
}
