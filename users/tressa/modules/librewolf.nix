{ config, host, lib, pkgs, ... }: {
  config = lib.optionalAttrs (host.session != null && host.session != "bspwm") {
    home.packages = with pkgs; [ librewolf ];
  };
}
