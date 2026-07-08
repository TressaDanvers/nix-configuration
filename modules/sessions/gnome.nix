{ pkgs, host, lib, ... }: {
  config = lib.optionalAttrs (host.session == "gnome") {
    environment = {
      systemPackages = with pkgs; [ gnome-console ];
      gnome.excludePackages = with pkgs; [ gnome-tour ];
    };

    documentation.enable = false;

    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        gnome-initial-setup.enable = false;
      };
    };
  };
}
