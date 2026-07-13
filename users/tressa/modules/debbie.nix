{ lib, pkgs, host, config, ... }: {
  config = lib.optionalAttrs (host.name == "debbie") {
    home.packages = with pkgs; [ (writeShellApplication { name = "factorio"; text = ''
      CONFIG="$HOME/.config/home-manager/users/tressa/config/factorio/config.ini"
      exec ${pkgs.umu-launcher}/bin/umu-run /opt/factorio/bin/x64/factorio --config "$CONFIG" "$@"
    '';}) ];

    xdg.desktopEntries = {
      votv = {
        name = "Voices of the Void";
        exec = "gamescope -W 1920 -H 1080 ${config.home.homeDirectory}/.local/opt/votv/VotV.exe";
        icon = ../resources/icons/VotV.ico;
        type = "Application";
        terminal = false;
        categories = [ "Game" ];
      };

      rivals = {
        name = "Marvel Rivals";
        exec = "steam steam://rungameid/2767030";
        icon = ../resources/icons/Rivals.ico;
        type = "Application";
        terminal = false;
        categories = [ "Game" ];
      };

      factorio = {
        name = "Factorio";
        exec = "factorio";
        icon = ../resources/icons/Factorio.ico;
        type = "Application";
        terminal = false;
        categories = [ "Game" ];
      };
    };
  };
}
