{ pkgs, host, lib, ... }: {
  config = lib.optionalAttrs (host.session == "kde-plasma") {
    environment = {
      systemPackages = with pkgs; with kdePackages; [ konsole ];
      plasma6.excludePackages = with pkgs; with kdePackages; [];
    };

    documentation.enable = false;

    services = {
      displayManager.plasma-login-manager.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };
}
