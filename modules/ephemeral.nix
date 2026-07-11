{ inputs, host, pkgs, lib, ... }: {
  imports = lib.lists.optional host.isEphemeral inputs.preservation.nixosModules.default;
  config = lib.attrsets.optionalAttrs host.isEphemeral {
    environment.etc."profile.d/home-manager-init.sh".source =
      pkgs.writeShellScript "home-manager-initializer.sh" ''
        if [ ! -e "$XDG_RUNTIME_DIR/home-manager-initialized" ]; then
          if [ ! -e "$HOME/.config/home-manager/flake.nix" ]; then
            ${pkgs.home-manager}/bin/home-manager init
          fi
          ${pkgs.home-manager}/bin/home-manager switch
          touch "$XDG_RUNTIME_DIR/home-manager-initialized"
        fi
      '';

    systemd.services."systemd-machine-id-commit".enable = false;

    users.mutableUsers = false;

    preservation = {
      enable = true;

      preserveAt."/state" = {
        directories = [
          { directory = "/var/lib/nixos"; inInitrd = true; }
          "/etc/nixos"
          "/var/lib/bluetooth"
        ];

        files = [
          { file = "/var/lib/sops-nix/keys.txt"; mode = "0600"; }
          { file = "/etc/machine-id"; inInitrd = true; }
        ];

        users = lib.genAttrs (host.users) (path: let
          user = (import ../users/${path} inputs).user;
        in {
          commonMountOptions = [
            "x-gvfs-hide"
            "x-gdu.hide"
          ];

          directories = [
            ".var/wine"
            ".config/home-manager"
            ".local/share/Steam"
            "Desktop"
            "Documents"
            "Downloads"
            "Music"
            "Pictures"
            "Public"
            "Projects"
            "Templates"
            "Videos"
          ] ++ user.state.directories;

          files = [
            { file = ".config/sops/age/keys.txt"; mode = "0600"; }
          ] ++ user.state.files;
        });
      };
    };
  };
}
