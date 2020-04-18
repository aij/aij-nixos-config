{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  console.keyMap = "dvorak";
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
     wget vim screen powertop htop lsof psmisc pwgen traceroute tree tcpdump zip unzip pciutils ethtool sdparm lsscsi rlwrap
     file usbutils bsdgames fping hdparm iotop finger_bsd openssl inetutils smartmontools sysstat beep numactl
     # unar
     sg3_utils
     nvme-cli
     ddrescue
     dmidecode
     memtester
     fio
     btrfs-progs xfsprogs
     lynx w3m
     git ack binutils ocaml
     ripgrep # rg
     rxvt_unicode.terminfo
     linuxPackages.bcc
     mkpasswd
     lm_sensors s-tui stress
  ];

  # Default changed in 5a5db609e5bd83bc589f36eef394f3ad172d6648 and 9df79de1a115920bd96a7d4e66bc3782865c8146
  programs.command-not-found.enable = true;

  programs.mtr.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers = {
    ivan = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "cdrom" ];
    };
    aij = {
      isNormalUser = true;
      uid = 1001;
      # If you crack this, let me know and I will send you a cookie. ;)
      initialHashedPassword = "$6$rounds=999999$aijinitialpass$DKAI93olFt5z4AKpcXK/QiQBqqPU1pHbG8.zMCnzbeGRhsss/WTUTE2azNsTBk3t0tuRdm6aGsuCC7/e/BnBe1";
    };
    ijager = {
      isNormalUser = true;
      uid = 1002;
    };
    bob = {
      isNormalUser = true;
      uid = 1003;
    };
  };

  nix.useSandbox = true;
  nix.trustedUsers = [ "bob" ];

  # pcspkr won't load automatically because it is blacklisted by
  # /etc/modprobe.d/ubuntu.conf
  # TODO: Patch/override pkgs.kmod-blacklist-ubuntu instead?
  boot.kernelModules = [ "pcspkr" ];
}
