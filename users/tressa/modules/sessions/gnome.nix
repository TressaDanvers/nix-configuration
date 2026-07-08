{ config, host, lib, pkgs, ... }: {
  config = lib.optionalAttrs (host.session == "gnome") {
    home = {
      packages = with pkgs; with gnomeExtensions; [
        librewolf
        nautilus
       rounded-window-corners-reborn
     ];

      activation.linkLibrewolfState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        if [ -d $HOME/.config/librewolf ]; then $DRY_RUN_CMD rm -rf $HOME/.config/librewolf; fi
        $DRY_RUN_CMD ln -srf $HOME/.var/config/librewolf $HOME/.config/librewolf
      '';
    };

    dbus.packages = with pkgs; [
      nautilus
    ];

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
