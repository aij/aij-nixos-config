{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../desktop.nix
      ../../dev.nix
      ../../stable.nix
      ../../bluetooth.nix
      ../../hosts-home.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
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
  networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant.
    interfaces = [ "wlan-sta0" ];
  };
  networking.wlanInterfaces = let device = "wlp3s0"; in
    {
      wlan-sta0 = { inherit device; };
      wlan-sta1 = { inherit device; mac = "02:69:74:61:00:01"; };
    };
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    libinput
    sysbench
    keepassx2
    # unetbootin
    # adb
    SDL2
    SDL2_image
    # kde4.kpat
    # gnome3.aisleriot
    # openarena zeroad openttd xonotic # ioquake3
    # esniper # Broken and unmaintained?
    icedtea8_web
    tetex
    ghostscriptX
    transmission
    rtorrent
    bitcoin
    iwd
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
      touchpad.tapping = false;
    };
  };

  #services.ipfs = { enable = true; autoMount = true; };
  #services.tor = {
  #  enable = true;
  #  client.enable = true;
  #};

  # networking.interfaces.enp0s25.ipv4.addresses = [
  #   { address = "10.0.4.1"; prefixLength = 24; }
  # ];
  services.dhcpd4 = {
    #enable = true;
    interfaces = [ "enp0s25" ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 10.0.4.255;
      #option routers 10.0.1.1;
      #option domain-name-servers 10.0.0.1, 8.8.8.8, 4.4.4.4;
      option domain-name "mrph.org";
      subnet 10.0.4.0 netmask 255.255.255.0 {
        range 10.0.4.140 10.0.4.250;
      }
      #allow booting;
      #allow bootp;
      #next-server 10.0.1.11;
      #filename "/pxelinux.0";
    '';
  };


  virtualisation.libvirtd.enable = true;

  nix = {
    useSandbox = true;
  };

  system.stateVersion = "16.09";
}
