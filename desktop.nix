{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [
   ./standard.nix
   #./dev.nix
 ];

  environment.systemPackages = with pkgs; [
    gkrellm
    gnupg
    wireshark # openssh_with_kerberos
    kismet
    xscreensaver
    (rxvt-unicode.override {
      configure = { availablePlugins, ... }: {
        plugins = with availablePlugins; [
          # None for now.
        ];
      };
    })
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
    deskflow # Fancier x2x / new upstream of Synergy
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
    # https://github.com/NixOS/nixpkgs/issues/369212
    gimp # gimp-with-plugins # Broken in unstable
    inkscape
    # enlightenment.rage enlightenment.terminology
    trayer
    haskellPackages.xmobar # TODO: Remove after fully switching to taffybar.
    # taffybar Broken in unstable :(
    audacity
    exif
    # exiftags # CVE-2023-50671, CVE-2024-42851
    keepassxc
    (pass.withExtensions (ext: with ext; [ pass-import pass-otp ]))
    browserpass
    bitwarden
    bitwarden-cli
    # androidsdk TODO: Where'd it go?
    graphviz
    sshfs-fuse
    ansible
    colmena
    lsdvd
    cdrkit
    dvdplusrwtools
    dvdbackup # Tool to backup DVDs
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

    # Fancy mouse cursors
    capitaine-cursors
    adwaita-icon-theme
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  services.displayManager.defaultSession = "none+xmonad";

  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    displayManager.startx.enable = true;
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        # extraPackages = p: [ p.taffybar ];
      };
    };
    logFile = null; # use default instead of /dev/null
  };
  services.xscreensaver.enable = true;

  programs.browserpass.enable = true;
  programs.firefox.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.ssh.startAgent = true;
  services.gnome = lib.optionalAttrs (builtins.hasAttr "gcr-ssh-agent" options.services.gnome) {
    # Conflicting alternative to plain ssh-agent
    gcr-ssh-agent.enable = false;
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu # Launcher (mod-X)
      waybar
      yambar
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

  # Firefox 72 broke ALSA support. :(
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

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

  xdg.icons.fallbackCursorThemes = ["Adwaita"];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"  # Needed by vintagestory

    # Needed by several things still... See them with
    # nix why-depends --all /run/current-system 'nixpkgs#libsoup_2_4'
    "libsoup-2.74.3"
  ];

}
