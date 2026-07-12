{ inputs, lib, pkgs, ... }: let
  ge-proton = inputs.ge-proton.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment = {
    systemPackages = [ ge-proton ];
    sessionVariables.PROTONPATH = ge-proton;
  };

  boot.binfmt.registrations.exe = {
    recognitionType = "magic";
    magicOrExtension = "MZ";
    interpreter = "${pkgs.umu-launcher}/bin/umu-run";
  };
}
