{ lib, host, ... }: {
  programs.gamescope = lib.optionalAttrs (host.session != "null") { enable = true; };
}
