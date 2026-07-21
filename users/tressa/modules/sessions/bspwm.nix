{ inputs, config, host, lib, pkgs, ... }: let
  ge-proton = inputs.ge-proton.packages.${pkgs.stdenv.hostPlatform.system}.default;
  standard-opacity = 0.35;
  panel-height = 28;
  panel-icons = 18;
in {
  config = lib.optionalAttrs (host.session == "bspwm") {
    home = {
      activation.reloadBspwm = lib.hm.dag.entryAfter [ "xfconfSettings" ] ''
        $DRY_RUN_CMD ${pkgs.bspwm}/bin/bspc wm -r
      '';

      packages = with pkgs; [
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
        pavucontrol
        xfce4-panel
        xfce4-whiskermenu-plugin
        nemo
      ];

      pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Ice";
        package = with pkgs; bibata-cursors;
        size = 24;
        x11.enable = true;
      };
    };

    gtk = let
      gtk-attrs = {
        enable = true;
        iconTheme = {
          name = "Moka";
          package = with pkgs; moka-icon-theme;
        };
      };
    in gtk-attrs // {
      gtk2 = gtk-attrs;
      gtk3 = gtk-attrs;
      gtk4 = gtk-attrs;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
        "application/epub+zip" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
      };
    };

    programs = {
      kitty = {
        enable = true;
        settings = {
          background_opacity = standard-opacity;
        };
      };

      mullvad-vpn = {
        enable = true;
      };

      feh.enable = true;

      zathura.enable = true;

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
         "steam_app_431960".state = "floating";
        };

        startupPrograms = [
          "xrdb -merge ~/.Xresources"
          "xsetroot -cursor_name left_ptr"
          "numlockx on"

          "pgrep -x sxhkd || sxhkd"
          "pgrep -x picom || picom"
          "pgrep -x xfce4-panel || xfce4-panel"
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
          WALLPAPERID="$(cat "$HOME"/.config/wallpaperid)"

          if [ "$WALLPAPERID" = "" ]; then
            feh --bg-scale --nofehbg ~/.config/home-manager/users/tressa/wallpaper-dark.jpg
          else
            pkill linux-wallpaper
            linux-wallpaperengine -r DP-3 -r HDMI-1 -b "$WALLPAPERID" --disable-parallax -s &
          fi

          bspc config -m DP-3 top_padding ${toString panel-height}
        '';
      };
    };

    xfconf = {
      enable = true;
      settings.xfce4-panel = {
        "configver" = 2;
        "panels" = [ 1 ];
        "panels/dark-mode" = true;

        "panels/panel-1/output-name" = "DP-3";
        "panels/panel-1/position" = "p=6;x=0;y=0";
        "panels/panel-1/position-locked" = true;
        "panels/panel-1/length" = 100;
        "panels/panel-1/size" = panel-height;
        "panels/panel-1/icon-size" = panel-icons;
        "panels/panel-1/enter-opacity" = 100;
        "panels/panel-1/leave-opacity" = 100;
        "panels/panel-1/background-rgba" = [ 0.1 0.1 0.1 (standard-opacity * 2) ];
        "panels/panel-1/background-style" = 1;
        "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 ];

        # 1: tasks
        "plugins/plugin-1" = "tasklist";
        "plugins/plugin-1/grouping" = false;
        "plugins/plugin-1/flat-buttons" = true;
        "plugins/plugin-1/show-handle" = false;
        "plugins/plugin-1/show-labels" = true;
        "plugins/plugin-1/show-tooltips" = false;
        "plugins/plugin-1/window-scrolling" = true;
        "plugins/plugin-1/include-all-workspaces" = true;

        # 2: gap
        "plugins/plugin-2" = "separator";
        "plugins/plugin-2/style" = 0;
        "plugins/plugin-2/expand" = true;

        # 3: system tray
        "plugins/plugin-3" = "systray";
        "plugins/plugin-3/icon-size" = panel-icons;
        "plugins/plugin-3/square-items" = true;
        "plugins/plugin-3/hidden-legacy-items" = [ "mullvad-gui" "flameshot" ];
        "plugins/plugin-3/hide-new-items" = false;

        # 4: gap
        "plugins/plugin-4" = "separator";
        "plugins/plugin-4/style" = 0;
        "plugins/plugin-4/expand" = false;

        # 5: clock
        "plugins/plugin-5" = "clock";
        "plugins/plugin-5/digital-layout" = 2;
        "plugins/plugin-5/digital-time-format" = "%H:%M";
        "plugins/plugin-5/digital-date-format" = "%Y-%m-%d";
        "plugins/plugin-5/tooltip-format" = "%A %d %B %Y";
      };
    };

    services = {
      linux-wallpaperengine = {
        enable = true;
      };

      picom = {
        enable = true;
        backend = "glx";

        fade = true;
        fadeDelta = 5;

        activeOpacity = 0.98;
        inactiveOpacity = 0.95;

        opacityRules = [
          "100:_NET_WM_STATE@ *= '_NET_WM_STATE_FULLSCREEN'"
          "100:_NET_WM_OPAQUE_REGION@:c"
          "100:window_type = 'popup_menu'"
          "100:window_type = 'dropdown_menu'"
          "100:window_type = 'utility'"
          "100:WM_CLASS = 'factorio'"
          "100:WM_CLASS = 'steam_app_431960'"
        ];

        extraConfig = ''
          transparent-clipping = true;
          transparent-clipping-exclude = [
            "_NET_WM_OPAQUE_REGION@:c",
            "window_type = 'popup_menu'",
            "window_type = 'dropdown_menu'",
            "window_type = 'utility'",
            "WM_CLASS = 'steam_app_431960'"
          ];
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
