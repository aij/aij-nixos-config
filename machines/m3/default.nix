{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../server.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.mirroredBoots = [
    { path = "/boot1"; devices = [ "/dev/disk/by-id/ata-HITACHI_HUA723030ALA640_YVHPR5LA" ]; }
    { path = "/boot2"; devices = [ "/dev/disk/by-id/ata-HITACHI_HUA723030ALA640_YVHP2TKA" ]; }
  ];

  networking.hostName = "m3";
  system.stateVersion = "21.05"; # Did you read the comment?
}
