{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../nixops.nix
      ../../zfs.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/wwn-0x5002361000244453" # Sun F80
    "/dev/disk/by-id/usb-ORACLE_UNIGEN-UFD_40D112003CF972C0-0:0" # temporary USB stick
    "/dev/disk/by-id/wwn-0x500117310017e884" # Sun F40
  ];

  networking.hostName = "m6";
  networking.hostId = "64fc5dd5";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

