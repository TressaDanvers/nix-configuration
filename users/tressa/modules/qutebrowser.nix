{ config, host, lib, pkgs, ... }: {
  config = lib.optionalAttrs (host.session == "bspwm") {
    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = false;

      searchEngines.DEFAULT = "https://noai.duckduckgo.com/?q={}";

      settings = {
        content = {
          cookies.accept = "no-3rdparty";
          blocking.method = "both";
          fullscreen.window = true;
        };

        url = {
          default_page = "https://noai.duckduckgo.com";
          start_pages = "https://noai.duckduckgo.com";
        };
      };

      greasemonkey = with pkgs; [
        (fetchurl {
          url = "https://raw.githubusercontent.com/TressaDanvers/youtube-adb/refs/heads/main/index.user.js";
          sha256 = "sha256-HJacrbNhHOSIvkU4BJE30B26PSjiHO5mplfLjAd6RjM=";
        })
      ];
    };
  };
}
