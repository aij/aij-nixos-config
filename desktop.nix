{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
    gkrellm
    gnupg
    wireshark # openssh_with_kerberos
    # kismet # broken in unstable
    xscreensaver
    rxvt-unicode
    terminus_font
    geeqie
    mplayer
    vlc
    mpv
    xorg.xinit
    xorg.xdpyinfo
    xorg.xbacklight
    xorg.xdriinfo
    xorg.xev
    xorg.xmodmap
    xfontsel
    x2x
    barrier # Fancier x2x / fork of Synergy
    xcompmgr
    read-edid
    edid-decode
    xrestop
    glxinfo
    xclip
    xdotool
    chromium
    #firefox #google-chrome # chromiumDev
    notmuch
    offlineimap
    msmtp
    muchsync
    lieer
    evince
    gphoto2
    gphoto2fs
    gthumb
    digikam
    darktable
    imagemagick
    obs-studio # Screen recorder
    gnumeric
    abiword
    libmtp # Transfer files from Android over MTP
    # pdfmod gnome3.gconf # hack: pdfmod needed gconf, but was later broken anyway
    gimp # gimp-with-plugins is broken in unstable
    inkscape
    # qgis # Broken in unstable https://github.com/NixOS/nixpkgs/issues/196432
    # enlightenment.rage enlightenment.terminology
    trayer
    haskellPackages.xmobar # TODO: Remove after fully switching to taffybar.
    # taffybar Broken in unstable :(
    audacity
    # fldigi # Broken because fldigi-4.1.19.tar.gz is no longer available from Sourceforge
    hackrf
    gqrx # SDR
    urh # Universal Radio Hacker (SDR tool)
    exif
    exiftags
    keepassxc
    (pass.withExtensions (ext: with ext; [ pass-import pass-otp ]))
    browserpass
    # androidsdk TODO: Where'd it go?
    graphviz
    sshfs-fuse
    ansible
    colmena
    lsdvd
    cdrkit
    dvdplusrwtools
    # dvdbackup # Tool to backup DVDs -- broken in unstable
    yt-dlp
    signal-desktop
    element-desktop
    (pidgin.override {
      plugins = [ purple-plugin-pack ];
    })
    # jitsi # video conferencing alternative to Hangouts / Zoom

    tetex
    ghostscriptX
    rclone
    google-drive-ocamlfuse
    # For getting pulseaudio to do something sane with sound https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/DefaultDevice/
    pavucontrol

    # Games
    endless-sky
    mindustry
    # flightgear # Broken in unstable
    # TODO: 0ad xonotic quake3 blobwars openttd gotypist gtypist gtetrinet ?
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    displayManager.startx.enable = true;
    displayManager.defaultSession = "none+xmonad";
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        # extraPackages = p: [ p.taffybar ];
      };
    };
    logFile = null; # use default instead of /dev/null
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;
  programs.browserpass.enable = true;
  programs.firefox.enable = true;
  programs.gnupg.agent = {
    enable = true;
  } //
  (if builtins.hasAttr "pinentryPackage" options.programs.gnupg.agent # False on NixOS 23.11
  then { pinentryPackage = pkgs.pinentry-qt; }
  else { pinentryFlavor = "qt"; }
  );

  programs.ssh.startAgent = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu # Launcher (mod-X)
      waybar
      swayidle
      swaylock-effects # swaylock with more features
      alacritty
      foot
      xwayland
      wev
      grim
      wl-clipboard
      slurp
      wf-recorder
      mako
      libnotify # for notify-send
    ];
  };

  sound.enable = true;
  # Firefox 72 broke ALSA support. :(
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  hardware.hackrf.enable = true;

  fonts = {
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      terminus_font # For urxvt / xterm
      font-awesome # For waybar
    ];
  };

  # Options for nixos-rebuild build-vm
  # (The default 384MB RAM is not enough to run Firefox)
  virtualisation =
    lib.optionalAttrs (builtins.hasAttr "qemu" options.virtualisation) {
      memorySize = 4096;
      cores = 4;
      # qemu.options = [ "-soundhw ac97" ];
    };

  # Needed by nixops. https://github.com/NixOS/nixops/issues/1242
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-cryptography-2.9.2"
    "python3.10-certifi-2022.9.24"
    "python3.10-certifi-2022.12.7"
  ];

}
