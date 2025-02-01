{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  #console.keyMap = "dvorak";
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "dvorak";
      options = "ctrl:nocaps, terminate:ctrl_alt_bksp, compose:ralt";
    };
    autoRepeatDelay = 160;
    autoRepeatInterval = 45;
  };


  # Set your time zone.
  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    wget
    vim
    screen
    powertop
    htop
    lsof
    psmisc
    pwgen
    traceroute
    tree
    tcpdump
    zip
    unzip
    pciutils
    ethtool
    sdparm
    lsscsi
    rlwrap
    file
    usbutils
    bsdgames
    fping
    hdparm
    iotop
    finger_bsd
    openssl
    inetutils
    smartmontools
    sysstat
    beep
    numactl
    # unar
    sg3_utils
    nvme-cli
    ddrescue
    rsync
    strace
    elfutils
    dmidecode
    lshw
    hwinfo
    neofetch # Pretty system info display
    fastfetch # Pretty system info display
    memtester
    fio
    cryptsetup
    btrfs-progs
    xfsprogs
    lynx
    w3m
    git
    git-annex
    git-lfs
    ack
    binutils
    ocaml
    ripgrep # rg
    du-dust # more graphical du / less graphical fsv
    fd # faster find alternative
    hyperfine # cmdline benchmarking tool
    rxvt-unicode-unwrapped.terminfo
    linuxPackages.bcc
    mkpasswd
    lm_sensors
    s-tui
    stress
    pv # monitor the progress of data through a pipe
    iperf # network bandwidth measurement tool
    nvd # NixOS diff tool
  ];

  # Set $WORDLIST to a reasonable equivalent to /usr/share/dict/words
  # https://github.com/NixOS/nixpkgs/issues/16545#issuecomment-1050281281
  environment.wordlist.enable = true;

  # Default changed in 5a5db609e5bd83bc589f36eef394f3ad172d6648 and 9df79de1a115920bd96a7d4e66bc3782865c8146
  programs.command-not-found.enable = true;

  programs.mtr.enable = true;
  services.netdata.enable = true;
  services.tailscale.enable = true;
  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers = {
    ivan = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "cdrom" "plugdev" ];
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
    ljager = {
      isNormalUser = true;
      uid = 1004;
    };
    tiff = {
      isNormalUser = true;
      uid = 1005;
    };
    chris = {
      isNormalUser = true;
      uid = 1006;
    };
    stnick = {
      isNormalUser = true;
      uid = 1007;
    };
    josiah = {
      isNormalUser = true;
      uid = 1008;
    };
    ans = {
      isNormalUser = true;
      uid = 1009;
    };
    nan = {
      isNormalUser = true;
      uid = 1010;
    };
    duff = {
      isNormalUser = true;
      uid = 1098;
    };
    lshelby = {
      isNormalUser = true;
      uid = 1099;
      description = "Leonard Shelby";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTGD3FImr4dsW6pmGT5muMDjEoOTPMxxvhwWMMyAcpC ivan@tobati"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORLMYgWkpO8Psfx9cI/kLtgrxo7M4sbgBL/4wNKQDvL ivan@ita"
      ];
    };
  };

  nix.daemonCPUSchedPolicy = "batch";
  nix.settings = {
    sandbox = true;
    trusted-users = [ "bob" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # pcspkr won't load automatically because it is blacklisted by
  # /etc/modprobe.d/ubuntu.conf
  # TODO: Patch/override pkgs.kmod-blacklist-ubuntu instead?
  boot.kernelModules = [ "pcspkr" ];

  boot.loader.grub.configurationLimit = 10;
  boot.loader.systemd-boot.configurationLimit = 10;
}
