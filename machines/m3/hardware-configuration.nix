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

      # Fast/unreliable FS created with
      # mkfs.btrfs -L scratch /dev/sd[a-l]1
      "/scratch" = { label = "scratch"; fsType = "btrfs"; options = [ "nofail" ]; };

      # Generated with
      # i=0; blkid -o udev /dev/sd[a-l]2 | grep ID_FS_PARTUUID | sed 's/ID_FS_PARTUUID/PARTUUID/' | while read dev; do printf '"/chia/%02d" = { device = "%s"; options = [ "nofail" ]; };\n' $i $dev; i=$((i+1)); done
      "/chia/00" = { device = "PARTUUID=4446cbf4-402f-9347-91c1-a642d78435e9"; options = [ "nofail" ]; };
      "/chia/01" = { device = "PARTUUID=90215a5b-b41e-3243-b9e9-a9fa48b2984a"; options = [ "nofail" ]; };
      "/chia/02" = { device = "PARTUUID=fb54665f-0425-6b44-9203-7c93566d681f"; options = [ "nofail" ]; };
      "/chia/03" = { device = "PARTUUID=843ed806-2c84-1544-9262-b4ff0cac3dfc"; options = [ "nofail" ]; };
      "/chia/04" = { device = "PARTUUID=86dff253-9d0d-6345-bd9e-dd19721be970"; options = [ "nofail" ]; };
      "/chia/05" = { device = "PARTUUID=e8132474-aadb-5040-9dae-348c15063464"; options = [ "nofail" ]; };
      "/chia/06" = { device = "PARTUUID=8f764159-a3ee-314d-8d6a-97aaa3926428"; options = [ "nofail" ]; };
      "/chia/07" = { device = "PARTUUID=fe60478c-7378-6b4b-8199-52ab261d7ab7"; options = [ "nofail" ]; };
      "/chia/08" = { device = "PARTUUID=ef3740d6-b442-3649-accb-b72ce4c171ac"; options = [ "nofail" ]; };
      "/chia/09" = { device = "PARTUUID=e123ab7d-c685-8b4e-bde7-27f386cf3666"; options = [ "nofail" ]; };
      "/chia/10" = { device = "PARTUUID=213df242-d7b0-b34d-970a-98a18db146cf"; options = [ "nofail" ]; };
      "/chia/11" = { device = "PARTUUID=a20e0811-be6a-7d40-95d7-9f3016c9dbda"; options = [ "nofail" ]; };
      # i=12; blkid -o udev /dev/sd[mn]4 | grep ID_FS_PARTUUID | sed 's/ID_FS_PARTUUID/PARTUUID/' | while read dev; do printf '"/chia/%02d" = { device = "%s"; options = [ "nofail" ]; };\n' $i $dev; i=$((i+1)); done
      "/chia/12" = { device = "PARTUUID=f9943744-3cc2-0347-a9e6-273933b634fb"; options = [ "nofail" ]; };
      "/chia/13" = { device = "PARTUUID=eb476a09-dd89-bf45-ae49-42fb0ad47c50"; options = [ "nofail" ]; };

    };

}
