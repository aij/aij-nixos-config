{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
     gkrellm
     gnupg wireshark # openssh_with_kerberos
     # kismet # broken in unstable
     xscreensaver rxvt_unicode terminus_font geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xorg.xev xorg.xmodmap xfontsel x2x
     xrestop
     xclip
     chromium  firefox #google-chrome # chromiumDev
     notmuch offlineimap msmtp
     evince gphoto2 gphoto2fs imagemagick gnumeric abiword
     libmtp # Transfer files from Android over MTP
     # pdfmod gnome3.gconf # hack: pdfmod needed gconf, but was later broken anyway
     gimp # gimp-with-plugins is broken in unstable
     inkscape
     # enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar # TODO: Remove after fully switching to taffybar.
     # taffybar Broken in unstable :(
     audacity fldigi
     exif exiftags
     keepassxc
     (pass.withExtensions (ext: with ext; [ pass-import pass-otp ]))
     browserpass
     # androidsdk TODO: Where'd it go?
     graphviz
     sshfs-fuse ansible nixops
     lsdvd handbrake cdrkit
     # dvdbackup # Tool to backup DVDs -- broken in unstable
     (pidgin.override {
       plugins = [ purple-plugin-pack ];
     })
     # jitsi # video conferencing alternative to Hangouts / Zoom

     tetex ghostscriptX
     rclone google-drive-ocamlfuse
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
    displayManager.defaultSession = "none+xmonad";
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
       # extraPackages = p: [ p.taffybar ];
      };
    };
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;
  programs.browserpass.enable = true;
  programs.gnupg.agent =
    { enable = true;  } //
    (if builtins.hasAttr "pinentryFlavor" options.programs.gnupg.agent # False on NixOS 19.09
     then { pinentryFlavor = "gtk2"; }
     else {});

  sound.enable = true;
  # Firefox 72 broke ALSA support. :(
  hardware.pulseaudio.enable = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
        terminus_font
    ];
  };

  # Options for nixos-rebuild build-vm
  # (The default 384MB RAM is not enough to run Firefox)
  virtualisation =
    lib.optionalAttrs (builtins.hasAttr "qemu" options.virtualisation) {
      memorySize = 4096;
      cores = 4;
      qemu.options = [ "-soundhw ac97" ];
    };
}
