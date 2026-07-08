{ lib, ... }: {
  options.user = {
    name = lib.mkOption { type = lib.types.nonEmptyStr; };
    desc = lib.mkOption { type = lib.types.nonEmptyStr; };
    secrets = lib.mkOption { type = lib.types.attrs; };
    internalModules = lib.mkOption { type = lib.types.listOf lib.types.path; };
  };
}
