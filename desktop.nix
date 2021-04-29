{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
    gkrellm
    gnupg
    wireshark # openssh_with_kerberos
    # kismet # broken in unstable
    xscreensaver
    rxvt_unicode
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
    firefox #google-chrome # chromiumDev
    notmuch
    offlineimap
    msmtp
    muchsync
    gmailieer
    evince
    gphoto2
    gphoto2fs
    imagemagick
    gnumeric
    abiword
    libmtp # Transfer files from Android over MTP
    # pdfmod gnome3.gconf # hack: pdfmod needed gconf, but was later broken anyway
    gimp # gimp-with-plugins is broken in unstable
    inkscape
    qgis
    # enlightenment.rage enlightenment.terminology
    trayer
    haskellPackages.xmobar # TODO: Remove after fully switching to taffybar.
    # taffybar Broken in unstable :(
    audacity
    fldigi
    exif
    exiftags
    keepassxc
    (pass.withExtensions (ext: with ext; [
      # pass-import # Broken in unstable https://github.com/NixOS/nixpkgs/issues/121188
      pass-otp
    ]))
    browserpass
    # androidsdk TODO: Where'd it go?
    graphviz
    sshfs-fuse
    ansible
    nixopsUnstable
    lsdvd
    cdrkit
    # dvdbackup # Tool to backup DVDs -- broken in unstable
    signal-desktop
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
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps, terminate:ctrl_alt_bksp, compose:ralt";
    autoRepeatDelay = 160;
    autoRepeatInterval = 45;
    enableCtrlAltBackspace = true;
    # Using startx is causing issues with Xmobar on 20.09... Not sure
    # why, but it should be fixed when later xserver module changes
    # land, so probably not worth spending too much time on.
    displayManager.startx.enable = builtins.hasAttr "logFile" options.services.xserver; # true after 20.09
    displayManager.defaultSession = "none+xmonad";
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        # extraPackages = p: [ p.taffybar ];
      };
    };
  } //
  (if builtins.hasAttr "logFile" options.services.xserver # False on NixOS 20.09
  then {
    logFile = null; # use default instead of /dev/null
  } else { });

  services.keybase.enable = true;
  services.kbfs.enable = true;
  programs.browserpass.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  programs.ssh.startAgent = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu # Launcher (mod-X)
      waybar
      swayidle
      swaylock-effects # swaylock with more features
      alacritty
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
  hardware.pulseaudio.enable = true;

  fonts = {
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      terminus_font # For urxvt / xterm
      font-awesome # For waybar
    ];
  } //
  (if builtins.hasAttr "fontDir" options.fonts # False on NixOS 20.09
  then { fontDir.enable = true; }
  else { enableFontDir = true; });

  # Options for nixos-rebuild build-vm
  # (The default 384MB RAM is not enough to run Firefox)
  virtualisation =
    lib.optionalAttrs (builtins.hasAttr "qemu" options.virtualisation) {
      memorySize = 4096;
      cores = 4;
      qemu.options = [ "-soundhw ac97" ];
    };

  # Needed by nixops. https://github.com/NixOS/nixops/issues/1242
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-cryptography-2.9.2"
  ];

}
