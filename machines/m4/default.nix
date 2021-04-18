{ config, lib, pkgs, nodes, ... }: {
  # Cisco C24 M3
  networking.hostName = "m4";
  networking.hostId = "8425e349";
  system.stateVersion = "17.09";

  imports =
    [
      ./hardware-configuration.nix
      ../../nixops.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-ST5000DM000-1FK178_W4J1VWW3";
}
