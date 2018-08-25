{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../zfs-unstable.nix
    ../../desktop.nix
    ../../dev.nix
    # ../../profiles/miner.nix
  ];

  networking.hostName = "tobati";
  networking.hostId = "235d6160";

  networking.hosts = (import ../../hosts-home.nix).networking.hosts;

  services.openssh.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];
  boot.kernelPackages = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor pkgs.linux_4_17);

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "18.03"; # Did you read the comment?

}
