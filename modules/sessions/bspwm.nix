{ pkgs, host, lib, ... }: {
  config = lib.optionalAttrs (host.session == "bspwm") {
    documentation.enable = false;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    programs = {
      dconf.enable = true;
      xfconf.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        windowManager.bspwm.enable = true;
        excludePackages = with pkgs; [ xterm ];
      };

      dbus.enable = true;

      displayManager.ly = {
        enable = true;
        x11Support = true;
      };

      mullvad-vpn = {
        enable = true;
        enableExcludeWrapper = true;
      };
    };
  };
}
