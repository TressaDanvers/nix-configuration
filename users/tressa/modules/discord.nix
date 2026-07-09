{ lib, pkgs, host, inputs, user, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  config = lib.optionalAttrs (host.session != null) {
    programs.nixcord = {
      enable = true;
      user = user.name;
      config.frameless = true;
      discord = {
        silenceNoModClientWarning = true;
        krisp.enable = true;
      };
    };
  };
}
