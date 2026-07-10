{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          ControllerMode = "bredr";
          Experimental = true;
          FastConnectable = true;
        };

        Policy.AutoEnable = true;
      };
    };
  };
}
