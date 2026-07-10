{ lib, ... }: let
  files = builtins.readDir ../users;
  users = lib.lists.flatten builtins.map builtins.attrNames lib.filterAttrs (_: type: type == "directory") files;
in {
  options.host = {
    arch = lib.mkOption { type = lib.types.enum [ "x86_64-linux" ]; };
    name = lib.mkOption { type = lib.types.nonEmptyStr; };

    session = lib.mkOption { type = lib.types.nullOr lib.types.enum [ "gnome" "kde-plasma" "bspwm" ]; };

    locale = lib.mkOption { type = lib.types.nonEmptyStr; };
    timeZone = lib.mkOption { type = lib.types.nonEmptyStr; };

    users = lib.mkOption { type = lib.types.listOf lib.types.enum users; };
    admin = lib.mkOption { type = lib.types.enum users; };

    isEphemeral = lib.mkOption { type = lib.types.bool; };
  };
}
