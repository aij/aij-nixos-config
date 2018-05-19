{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../zfs-unstable.nix
    ../../sshd.nix
    ../../desktop.nix
    ../../dev.nix
  ];

  networking.hostName = "tobati";
  networking.hostId = "235d6160";

  services.openssh.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  system.stateVersion = "18.03"; # Did you read the comment?

}
