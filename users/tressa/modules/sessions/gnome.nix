{ config, host, lib, pkgs, ... }: {
  config = lib.optionalAttrs (host.session == "gnome") {
    home = {
      packages = with pkgs; with gnomeExtensions; [
        librewolf
        nautilus
        rounded-window-corners-reborn
      ];
    };

    dbus.packages = with pkgs; [ nautilus ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          always-show-log-out = true;
          favorite-apps = [];
          disabled-extensions = [];
          enabled-extensions = [ "rounded-window-corners@fxgn" ];
        };
      };
    };
  };
}
