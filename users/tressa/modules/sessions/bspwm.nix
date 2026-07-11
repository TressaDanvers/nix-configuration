{ inputs, config, host, lib, pkgs, ... }: let
  ge-proton = inputs.ge-proton-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
  standard-opacity = 0.35; 
in {
  config = lib.optionalAttrs (host.session == "bspwm") {
    home.packages = with pkgs; [
      (writeShellScriptBin "screenshot" ''
        case "$1" in
          select) flameshot gui ;;
          full) flameshot screen -p ~/Pictures/Screenshots/Snips/ ;;
          delayed) flameshot gui -n 2 ;;
        esac
      '')
      (pkgs.writeShellScriptBin "gamescope" ''
        export WINEPREFIX='${config.home.homeDirectory}/.var/wine'
        export PROTONPATH='${ge-proton}'
        exec ${pkgs.gamescope}/bin/gamescope "$@"
      '')
      numlockx
    ];

    programs = {
      kitty = {
        enable = true;
        settings = {
          background_opacity = standard-opacity;
        };
      };

      feh.enable = true;

      vicinae = {
        enable = true;
        systemd.enable = true;
        settings = {
          launcher_window = {
            opacity = standard-opacity * 2;
            client_side_decorations = {
              rounding = 0;
              border_width = 0;
              shadow_size = 0;
            };
          };
        };
      };
    };

    xsession = {
      initExtra = ''
        systemctl --user import-environment WINEPREFIX PROTONPATH
      '';

      windowManager.bspwm = {
        enable = true;

        rules = {
         "flameshot".state = "fullscreen";
        };

        startupPrograms = [
          "pgrep -x sxhkd || sxhkd"
          "pgrep -x picom || picom"
        ];

        monitors = {
          DP-3 = [ "primary" "hidden" ];
          HDMI-1 = [ "secondary" ];
        };

        settings = {
          border_width = 2;
          window_gap = 12;
          split_ratio = 0.5;

          borderless_monocle = true;
          gapless_monocle = true;

          pointer_modifier = "mod1";
          focus_follows_pointer = true;
        };

        extraConfig = ''
          numlockx on
          feh --bg-scale --nofehbg ~/.config/home-manager/users/tressa/wallpaper-dark.jpg
        '';
      };
    };

    services = {
      picom = {
        enable = true;
        backend = "glx";
        extraConfig = ''
          transparent-clipping = true;
        '';
      };

      flameshot = {
        enable = true;
        settings.General = {
          useX11LegacyScreenshot = true;
          captureActiveMonitor = true;
        };
      };

      sxhkd = {
        enable = true;

        keybindings = {
          # Session Management
          "alt + super + {q,r}" = "bspc {quit,wm -r}";
          "XF86Audio{Raise,Lower}Volume" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%{+,-}";
          "XF86AudioMute" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "alt + super + {Up,Down}" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%{+,-}";
          "Print" = "screenshot select";
          "alt + Print" = "screenshot full";
          "alt + shift + Print" = "screenshot delayed";

          # Application Shortcuts
          "alt + Return" = "kitty";
          "alt + space" = "vicinae open";
          "alt + w" = "qutebrowser";

          # Window Management
          "alt + m" = "bspc desktop -l next";
          "alt + {a,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
          "alt + {_,shift +} q" = "bspc node -{c,k}";
          "alt + {_,shift + }Tab" = "bspc node -f {next,prev}.local.!hidden.window";
          "alt + {_,shift + ,ctrl + }{Left,Down,Up,Right}" = "bspc node -{f,s,p} {west,south,north,east}";
          "alt + ctrl + space" = "bspc node -p cancel";
          "alt + {_,shift + }{1,2}" = "bspc {desktop -f,node -d} '^{1,3}'";
          "alt + {_,shift + }h" = "bspc {desktop -f,node -d} '^{2}'";
        };
      };
    };
  };
}
