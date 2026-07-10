{ lib, host, ... }: {
  config = lib.optionalAttrs (host.name == "debbie") {
    
  };
}
