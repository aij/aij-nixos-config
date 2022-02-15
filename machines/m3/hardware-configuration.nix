{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "uhci_hcd" "mpt3sas" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems =
    {
      "/" = {
        label = "root"; # Warning: Device configured by nixos-generate-config did not work.
        fsType = "btrfs";
        options = [ "compress=zstd" ];
      };

      "/boot1" =
        {
          device = "/dev/disk/by-uuid/9fd2b6e7-82f1-49d8-8c21-641f6e4261fe";
          fsType = "ext4";
          options = [ "nofail" ];
        };

      "/boot2" =
        {
          device = "/dev/disk/by-uuid/0b6ec62c-c809-46e6-b4b6-8ddf9d4fe6d6";
          fsType = "ext4";
          options = [ "nofail" ];
        };

      # Fast/unreliable FS originally created with
      # mkfs.btrfs -L scratch /dev/sd[a-l]1
      # later moved to /dev/sd[a-f]
      "/scratch" = { label = "scratch"; fsType = "btrfs"; options = [ "nofail" ]; };

      "/scratch2" = { label = "scratch2"; fsType = "btrfs"; options = [ "nofail" ]; };

      # Generated with
      # i=12; blkid -o udev /dev/sd[mn]4 | grep ID_FS_PARTUUID | sed 's/ID_FS_PARTUUID/PARTUUID/' | while read dev; do printf '"/chia/%02d" = { device = "%s"; options = [ "nofail" ]; };\n' $i $dev; i=$((i+1)); done
      "/chia/12" = { device = "PARTUUID=f9943744-3cc2-0347-a9e6-273933b634fb"; options = [ "nofail" ]; };
      "/chia/13" = { device = "PARTUUID=eb476a09-dd89-bf45-ae49-42fb0ad47c50"; options = [ "nofail" ]; };

    };

}
