{ config, pkgs, ... }:

{
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
     file usbutils bsdgames fping hdparm iotop finger_bsd openssl inetutils unar smartmontools
     zfs btrfs-progs
     lynx w3m
     git ack binutils ocaml emacs 
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ivan = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "cdrom" ];
   };
  users.extraUsers.aij = {
    isNormalUser = true;
    uid = 1001;
  };
} 
