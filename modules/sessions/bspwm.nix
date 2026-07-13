{ pkgs, host, lib, ... }: {
  config = lib.optionalAttrs (host.session == "bspwm") {
    documentation.enable = false;

    services = {
      xserver = {
        enable = true;
        windowManager.bspwm.enable = true;
        excludePackages = with pkgs; [ xterm ];
      };

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
