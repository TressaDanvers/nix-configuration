{ host, pkgs, lib, ... }: {
  config = lib.optionalAttrs (host.session != null) {
    programs.steam.enable = true;
  };
}
