# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "isci" "nvme" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
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
      device = "/dev/disk/by-uuid/6B36-6305";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 32;
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
