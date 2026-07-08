{ inputs, host, lib, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops = {
    defaultSopsFile = ../users/${host.admin}/secrets.yaml;
    age.keyFile = (lib.strings.optionalString host.isEphemeral "/state") +
      "/var/lib/sops-nix/keys.txt";
    secrets.passwd.neededForUsers = true;
  };
}
