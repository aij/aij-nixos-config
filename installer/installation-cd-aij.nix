# https://nixos.org/nixos/manual/index.html#sec-building-cd
# Build with
# cd nixpkgs/nixos
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=installer/installation-cd-aij.nix
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
    ];

  boot.supportedFilesystems = [ "zfs" ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
     wget vim screen latencytop powertop htop lsof psmisc pwgen traceroute mtr tree tcpdump zip unzip pciutils ethtool sdparm lsscsi rlwrap
     file usbutils bsdgames fping hdparm iotop finger_bsd openssl inetutils unar smartmontools sysstat beep numactl
     zfs btrfs-progs xfsprogs
     lynx w3m
     git ack binutils ocaml
     rxvt_unicode.terminfo

     megacli
  ];

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAm/qx6C2ZvSTGlUJXvucKpOs2rx6B1XnJWo0I8IYyCYoQxzjjNEwcLiy7bgOCjfYNqb2z/5XlMuspa0S32sUx0Z3WuJe9g6HOMzpxxaS9iYVW4eXtfpkbXBBkwXrwaFQ/3NX+/12cgj+8hgkkQFFBBUdUcU1UBRrBo9N5MqCSpjkDKFpFObSQ/gAu9Rv0cgQD4nRSvktEkd/43tI0PE+DLW0/xB6DOCN76eAEK9vB+EvPXndzAkaChF+ICmX6CLfSQVHPzujkQrFVVQCIWR2kQgtIFCh28hIp8wRJko3bUyN3oY40fFxAriP70ze3RX2M6GzuH4oN88rGCOW2WT08P/6hcqPZWQQxr7ZlWn/e1dFTH3RJluiitQ3Em7Z1jHfTy/1NWRl2s0+ZEUA1H9uUUvejPUo5J15Vjrepc7RGZ0CWtU2aP+nTTQQfvDizMiVXMNyIoUl8uTJt8zn8loLx82O8qrZ3D+7fbV2mXUlJVmG/aZvlU86dDX8BLU29B1LBFaLd3bJnIoZ/JnTEKXYKs/vZaFiU/IQpw80Ev91P5KkXsxOssIL5VpZ7S4nAUz+0FjPEeQfj0lnjb5a7nFhIFG7K46p95HUrmojJ3+6jzKUHMQdVEefYRKYo/yDK63PF2JMzDnkTO0t4rSeAqXHE47Vv8MrbgWOQ/w4HyZccmMc= aij@ita"
  ];
  # For the Mac Pro
  networking.enableB43Firmware = true;
  nixpkgs.config.allowUnfree = true;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "linksys" = {};
  };
}
