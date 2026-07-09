{ lib, pkgs, host, ... }: {
  config = lib.optionalAttrs (host.session != null) {
    home.packages = with pkgs; [ godot ];
  };
}
