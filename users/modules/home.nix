{ user, lib, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home = {
    activation.removeNixDefexpr = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD rm -rf "$HOME/.nix-defexpr"
    '';

    username = user.name;

    homeDirectory = if (user.name == "root") then "/root" else "/home/${user.name}";

    stateVersion = "26.05";
  };
}
