{ config, host, lib, pkgs, ... }: let
  standard-opacity = 0.35; 
in {
  config = lib.optionalAttrs (host.session == "bspwm") {
    home.packages = with pkgs; [ numlockx ];

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

    xsession.windowManager.bspwm = {
      enable = true;

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
        feh --bg-scale ~/.config/home-manager/users/tressa/wallpaper-dark.jpg
      '';
    };

    services = {
      picom = {
        enable = true;
        backend = "glx";
        extraConfig = ''
          transparent-clipping = true;
        '';
      };

      sxhkd = {
        enable = true;

        keybindings = {
          # Session Management
          "alt + super + {q,r}" = "bspc {quit,wm -r}";

          # Application Shortcuts
          "alt + Return" = "kitty";
          "alt + space" = "vicinae open";
          "alt + w" = "librewolf";

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
