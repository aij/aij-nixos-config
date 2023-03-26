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
      ../../zfs.nix
      ../../nextcloud-container.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.mirroredBoots = [
    { path = "/boot1"; devices = [ "/dev/disk/by-id/wwn-0x500051600003d818" ]; }
    { path = "/boot2"; devices = [ "/dev/disk/by-id/wwn-0x50005160000406b4" ]; }
  ];

  networking.hostName = "m2";
  networking.hostId = "cfefce5f";

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
