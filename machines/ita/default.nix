{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../desktop.nix
      ../../dev.nix
      ../../stable.nix
      ../../bluetooth.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 25;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/266207e6-0f45-402e-85f3-c013128605fb";

  # HDMI audio output should not be primary.
  boot.extraModprobeConfig = ''
    options snd-hda-intel index=1,0
  '';

  networking.hostName = "ita";
  networking.hostId = "49e32584";
  networking.domain = "mrph.org";
  networking.hosts = (import ../../hosts-home.nix).networking.hosts;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     libinput
     sysbench
     keepassx2
     # unetbootin
     # adb
     SDL2 SDL2_image
     # kde4.kpat
     gnome3.aisleriot
     # openarena zeroad openttd xonotic # ioquake3
     esniper
     icedtea8_web
     tetex ghostscriptX
     transmission rtorrent
     bitcoin
  ];

  programs.adb.enable = true;

  services.xserver = {
    synaptics = {
      enable = false; #true;
	    twoFingerScroll = true;
    };
    videoDrivers = [ "intel" ];
    modules = with pkgs.xorg; [ xf86inputsynaptics ];
    monitorSection = ''
      #DisplaySize 344 193
      DisplaySize 340 190
    '';
    libinput = {
      enable = true;
      tapping = false;
    };
  };

  services.ipfs = {
    enable = true;
    autoMount = true;
  };
  #services.tor = {
  #  enable = true;
  #  client.enable = true;
  #};

  virtualisation.libvirtd.enable = true;

  nix = {
    useSandbox = true;
    # Don't build big-parallel jobs locally
    systemFeatures =  [ "nixos-test" "benchmark" "kvm" ];
    distributedBuilds = true;
    buildMachines = [{
      hostName = "tobati";
      sshUser = "bob";
      system = "x86_64-linux";
      maxJobs = 32;
      speedFactor = 5;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }];
  };

  system.stateVersion = "16.09";
}
