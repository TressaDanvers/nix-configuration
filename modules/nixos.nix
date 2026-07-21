inputs@{ host, lib, pkgs, config, ... }: {
  time.timeZone = host.timeZone;
  i18n.defaultLocale = host.locale;
  nixpkgs.hostPlatform = host.arch;
  networking.hostName = host.name;

  fileSystems."/c" = let
    primaryUserConfig = "/home/${host.admin}/.config/home-manager";
  in {
    depends = [ primaryUserConfig ];
    device = primaryUserConfig;
    fsType = "none";
    options = [ "bind" ];
  };

  users.users = lib.attrsets.genAttrs host.users (path: let
    user = (import ../users/${path} inputs).user;
  in {
    name = user.name;
    description = user.desc;

    extraGroups = lib.lists.optional (user.name == host.admin) "wheel";

    hashedPasswordFile = if (host.admin == user.name &&
                         config.sops.secrets.passwd.path != null &&
                         config.users.mutableUsers == false)
      then config.sops.secrets.passwd.path
      else null;

    initialPassword = if (config.users.users.${user.name}.hashedPasswordFile == null)
      then "password"
      else null;

    isNormalUser = true;
  });

  nix = {
    channel.enable = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    loginShellInit = ''
      if [ $UID == 0 ]; then
        echo $'\033[1;31m'"fatal error:"$'\033[0m'" no root shell access, please use "$'\033[1m'"sudo"$'\033[0m' > /dev/stderr
        exit 1
      fi
      for f in /etc/profile.d/*; do . "$f"; done
    '';
    systemPackages = with pkgs; [ home-manager ];
  };

  networking.networkmanager.enable = true;

  system.stateVersion = "26.05";
}
