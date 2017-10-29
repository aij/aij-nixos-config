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
     file usbutils bsdgames fping hdparm iotop finger_bsd openssl inetutils unar smartmontools sysstat beep numactl
     zfs btrfs-progs xfsprogs
     lynx w3m
     git ack binutils ocaml
     rxvt_unicode.terminfo
     # Customized emacs package
     (import pkg/emacs.nix { inherit pkgs; })
  ];

  # Default changed in 5a5db609e5bd83bc589f36eef394f3ad172d6648 and 9df79de1a115920bd96a7d4e66bc3782865c8146
  programs.command-not-found.enable = true;

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
