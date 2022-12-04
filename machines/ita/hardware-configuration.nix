# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "rpool/ROOT";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/HOME";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/C461-EA67";
      fsType = "vfat";
    };

  fileSystems."/home/aij" =
    {
      device = "rpool/HOME/aij";
      fsType = "zfs";
    };

  fileSystems."/data" =
    {
      device = "rpool/DATA";
      fsType = "zfs";
    };

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 8;
}
