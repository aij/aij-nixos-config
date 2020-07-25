{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../standard.nix
      ../../desktop.nix
      ../../zfs.nix
      ../../unstable.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1";

  networking = {
    hostName = "belen";
    hostId = "78a4e399";
    networkmanager.enable = true;
  };
  boot.zfs.enableUnstable = true;
  nixpkgs.config.allowUnfree = true;

  users.extraUsers.ijager.extraGroups = [ "networkmanager" "docker" ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    vpnc
    wirelesstools
    # gnome3.gnome-keyring
    slack-dark
    zoom-us
    davmail
    # thunderbird
    lz4
  ];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Workaround for excessive thermal throttling.
  services.throttled.enable = true;

  # Reduce pparanoia. Needed for rr to record debugging traces.
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;

  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
