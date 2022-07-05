# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../sshd.nix
      ../../standard.nix
      ../../stable.nix
      ../../hosts-home.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "picam";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = false;
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" "8.8.8.8" "4.4.4.4" ];

  # networking.wlanInterfaces =
  services.hostapd = {
    enable = true;
    ssid = "picam";
    wpa = true;
    wpaPassphrase = "testingpassword";
    interface = "wlan0";
  };

  networking.interfaces."wlan0".ipv4.addresses =
    lib.optionals config.services.hostapd.enable [{ address = "10.0.8.8"; prefixLength = 24; }];


  environment.systemPackages = with pkgs; [
    libcamera
    libraspberrypi
    motion
    wirelesstools
    iw
  ];

  services.zoneminder = {
    #enable = true;
    #cameras = 2;
    database.createLocally = true;
    database.username = "zoneminder";
    openFirewall = true;
  };

  services.mjpg-streamer = {
    enable = true;
    #inputPlugin = "input_uvc.so -r 1920x1080";
    inputPlugin = "input_uvc.so -r 1280x720";
    outputPlugin = "output_http.so -w @www@ -n -p 8000";
  };
  networking.firewall.allowedTCPPorts = [ 8000 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

