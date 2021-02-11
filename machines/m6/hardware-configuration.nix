# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "mpt3sas" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/ROOT";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/NIX";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "rpool/VAR";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/HOME";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-id/md-uuid-cdc075ef:e1abebc8:9cace087:7700c333";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 64;
}
