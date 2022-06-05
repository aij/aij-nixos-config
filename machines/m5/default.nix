# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
  boot.loader.grub.devices = [
    "/dev/disk/by-id/ata-MTFDDAK256MAR-1K1AA_90Y8664_90Y8667IBM_0344FDEB-part2"
    "/dev/disk/by-id/wwn-0x5001173100179f60" # Sun F40
    "/dev/disk/by-id/wwn-0x5001173100181ddc" # Sun F40
  ];

  networking.hostId = "1f9081c2";
  networking.hostName = "m5";

  services.openssh.enable = true;

  system.stateVersion = "18.09"; # Did you read the comment?

}
