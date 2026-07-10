{ nixpkgs, ... }: {
  host = {
    arch = "x86_64-linux";
    name = "nixos";

    session = "bspwm";

    locale = "en_US.UTF-8";
    timeZone = "America/New_York";

    admin = "tressa";
    users = [ "tressa" ];

    isEphemeral = true;
  };
}
