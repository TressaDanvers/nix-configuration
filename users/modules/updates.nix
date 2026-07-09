{ lib, pkgs, host, user, ... }: {
  home.packages = with pkgs; let
    sync-updates = (writeShellApplication {
      name = "sync-updates";
      text = ''
        pushd "$HOME/.config/home-manager" >/dev/null
        echo $'\033[1;34m'"info:"$'\033[0m'" synchronizing updates from $(jj git remote list 2>/dev/null)"
        jj git fetch
        jj rebase -b @ -d master
        popd >/dev/null
      '';
    });

    sync-updates-to-system = (writeShellApplication {
      name = "sync-updates-to-system";
      text = ''
        sync-updates
        echo $'\033[1;33m'"warn:"$'\033[0m'" synchronizing updates to /etc/nixos, "$'\033[1m'"sudo"$'\033[0m'" required, commands follow"
        echo "  "$'\033[1m'"sudo"$'\033[0m'" rm -r /etc/nixos/{*,.*}"
        sudo rm -r /etc/nixos/{*,.*}
        echo "  "$'\033[1m'"sudo"$'\033[0m'" cp ~/.config/home-manager/{*,.*} -r /etc/nixos/"
        sudo cp ~/.config/home-manager/{*,.*} -r /etc/nixos/
      '';
    });

    upgrade = (writeShellApplication {
      name = "upgrade";
      text = ''
        sync-updates
        echo $'\033[1;34m'"info:"$'\033[0m'" pushing updates to active session"
        home-manager switch
      '';
    });   

    upgrade-system = (writeShellApplication {
      name = "upgrade-system";
      text = ''
        if [[ "$1" != "switch" && "$1" != "boot" ]]; then
          echo $'\033[1;31m'"fatal error:"$'\033[0m'" invalid option: \"$1\", must be \"switch\" or \"boot\"" >&2; exit 1
        fi
        sync-updates-to-system
        echo $'\033[1;33m'"warn:"$'\033[0m'" pushing updates to active system, "$'\033[1m'"sudo"$'\033[0m'" required, commands follow"
        echo "  "$'\033[1m'"sudo"$'\033[0m'" nixos-rebuild \"$1\""
        sudo nixos-rebuild "$1"
      '';
    });   

    full-upgrade = (writeShellApplication {
      name = "full-upgrade";
      text = ''
        if [[ "$1" != "switch" && "$1" != "boot" ]]; then
          echo $'\033[1;31m'"fatal error:"$'\033[0m'" invalid option: \"$1\", must be \"switch\" or \"boot\"" >&2; exit 1
        fi
        sync-updates-to-system
        if [ "$1" = "switch" ]; then
          echo $'\033[1;33m'"warn:"$'\033[0m'" pushing updates to active system, "$'\033[1m'"sudo"$'\033[0m'" required, commands follow"
          echo "  "$'\033[1m'"sudo"$'\033[0m'" nixos-rebuild switch"
          sudo nixos-rebuild switch
          echo $'\033[1;34m'"info:"$'\033[0m'" pushing updates to active session"
          home-manager switch
        else
          echo $'\033[1;33m'"warn:"$'\033[0m'" staging updates to next boot, "$'\033[1m'"sudo"$'\033[0m'" required, commands follow"
          echo "  "$'\033[1m'"sudo"$'\033[0m'" nixos-rebuild boot"
          sudo nixos-rebuild boot
        fi
      '';
    });
  in [ sync-updates upgrade ] ++
    (lib.lists.optionals (host.admin == user.name) [ sync-updates-to-system upgrade-system full-upgrade ]);

  xdg.dataFile = lib.mkIf (host.admin == user.name) {
    "bash-completion/completions/upgrade-system".text = ''
      _upgrade_system_completions() {
        if [ "$COMP_CWORD" -eq 1 ]; then
          COMPREPLY=($(compgen -W "switch boot" -- "''${COMP_WORDS[1]}"))
        fi
      }
      complete -F _upgrade_system_completions upgrade-system
    '';

    "bash-completion/completions/full-upgrade".text = ''
      _full_upgrade_completions() {
        if [ "$COMP_CWORD" -eq 1 ]; then
          COMPREPLY=($(compgen -W "switch boot" -- "''${COMP_WORDS[1]}"))
        fi
      }
      complete -F _full_upgrade_completions full-upgrade
    '';
  };
}
