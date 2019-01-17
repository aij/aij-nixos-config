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
  boot.kernelPackages = pkgs.linuxPackages_4_19;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "18.03"; # Did you read the comment?

  # Hack for getting efibootmgr while testing nixpkgs commits where it doesn't compile
  nixpkgs.overlays = [ (self: super: { 
    efibootmgr = 
      let oldpkgs = import (builtins.fetchGit {
        name = "nixos-unstable-older-efibootmgr-hack";
        url = https://github.com/nixos/nixpkgs/;
        rev = "3ab361cb57b1c37a46b568e97d2e5025a1361c0c";
      }) {};
      in oldpkgs.efibootmgr;
   }) ];

}
