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

    home = {
      activation.linkDiscordState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        if [ -d $HOME/.config/discord ] && [ ! -L $HOME/.config/discord ]; then
          $DRY_RUN_CMD cp -r $HOME/.config/discord $HOME/.var/config/
          $DRY_RUN_CMD rm -r $HOME/.config/discord
        fi
        if [ -e $HOME/.config/discord ]; then
          $DRY_RUN_CMD rm $HOME/.config/discord
        fi
        $DRY_RUN_CMD ln -sr $HOME/.var/config/discord $HOME/.config/discord
      '';
    };
  };
}
