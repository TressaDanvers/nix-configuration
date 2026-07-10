{ pkgs, host, lib, ... }: {
  config = lib.optionalAttrs (host.session == "bspwm") {
    documentation.enable = false;

    services = {
      xserver = {
        enable = true;
        windowManager.bspwm.enable = true;
      };

      displayManager.ly = {
        enable = true;
        x11Support = true;
      };
    };
  };
}
