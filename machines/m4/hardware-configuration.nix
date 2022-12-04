# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "mpt3sas" "usbhid" "usb_storage" "sd_mod" ];
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
      device = "/dev/disk/by-uuid/4B81-10B5";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 32;
  powerManagement.cpuFreqGovernor = "powersave";
}
