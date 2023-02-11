# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "mpt3sas" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "rpool/ROOT";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rpool/NIX";
      fsType = "zfs";
    };

  fileSystems."/var" =
    {
      device = "rpool/VAR";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/HOME";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1F79-1EA4";
      fsType = "vfat";
    };

  fileSystems."/boot1" =
    {
      device = "/dev/disk/by-uuid/62C0-915F";
      fsType = "vfat";
    };

  fileSystems."/boot2" =
    {
      device = "/dev/disk/by-uuid/0E88-691C";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
