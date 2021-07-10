# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
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

  fileSystems."/" =
    {
      label = "root"; # Warning: Device configured by nixos-generate-config did not work.
      fsType = "btrfs";
    };

  fileSystems."/boot1" =
    {
      device = "/dev/disk/by-uuid/9fd2b6e7-82f1-49d8-8c21-641f6e4261fe";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  fileSystems."/boot2" =
    {
      device = "/dev/disk/by-uuid/0b6ec62c-c809-46e6-b4b6-8ddf9d4fe6d6";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  swapDevices = [ ];

}
