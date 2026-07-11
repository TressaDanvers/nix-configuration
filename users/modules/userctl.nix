{ lib, ... }: {
  options.user = {
    name = lib.mkOption { type = lib.types.nonEmptyStr; };
    desc = lib.mkOption { type = lib.types.nonEmptyStr; };

    state = {
      files = lib.mkOption { type = lib.types.listOf lib.types.any; };
      directories = lib.mkOption { type = lib.types.listOf lib.types.any; };
    };
  };
}
