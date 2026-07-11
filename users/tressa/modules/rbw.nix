{ pkgs, ... }: {
  programs.rbw = {
    enable = true;
    settings = {
      email = "acclegoking@protonmail.ch";
      pinentry = with pkgs; pinentry-tty;
    };
  };
}
