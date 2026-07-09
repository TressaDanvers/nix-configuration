{ config, host, lib, pkgs, ... }: {
  config = lib.optionalAttrs (host.session != null) {
    home.packages = with pkgs; [ librewolf ];
  };
}
