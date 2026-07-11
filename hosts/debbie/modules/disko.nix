{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];

  fileSystems = {
    "/nix".neededForBoot = true;
    "/state".neededForBoot = true;

    "/mnt/data" = {
      device = "/dev/disk/by-uuid/d13ec835-a186-4f7b-83b2-0b0df588d145";
      fsType = "ext4";
    };

    "/opt" = {
      depends = [ "/mnt/data" ];
      device = "/mnt/data/opt";
      fsType = "none";
      options = [ "bind" ];
    };

    "/srv" = {
      depends = [ "/mnt/data" ];
      device = "/mnt/data/srv";
      fsType = "none";
      options = [ "bind" ];
    };

    "/state/home/tressa/.local/share/Steam" = {
      depends = [ "/state" "/mnt/data" ];
      device = "/mnt/data/home/tressa/.local/opt/steam-home/.steam/debian-installation";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  disko.devices.nodev = {
    "/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=25%"
        "mode=755"
      ];
    };
  };

  disko.devices.disk.main = {
    device = "/dev/sdb";
    type = "disk";

    content.type = "gpt";

    content.partitions.boot = {
      name = "boot";
      size = "1M";
      type = "EF02";
    };

    content.partitions.esp = {
      name = "ESP";
      size = "1G";
      type = "EF00";

      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
      };
    };

    content.partitions.swap = {
      size = "4G";

      content = {
        type = "swap";
        resumeDevice = true;
      };
    };

    content.partitions.root = {
      name = "root";
      size = "100%";

      content = {
        type = "btrfs";
        extraArgs = ["-f"];

        subvolumes = {
          "/state" = {
            mountOptions = ["subvol=state" "noatime"];
            mountpoint = "/state";
          };

          "/nix" = {
            mountOptions = ["subvol=nix" "noatime"];
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
