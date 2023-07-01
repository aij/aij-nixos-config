{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../server.nix
      ../../zfs.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/wwn-0x500117310017e884" # Sun F40 (slot 3)
    "/dev/disk/by-id/wwn-0x50011731001832ec" # Sun F40 (slot 4)
  ];

  networking.hostName = "m6";
  networking.hostId = "64fc5dd5";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
