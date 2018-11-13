{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
     gkrellm
     gnupg kismet wireshark # openssh_with_kerberos
     xscreensaver rxvt_unicode terminus_font geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xorg.xev xorg.xmodmap xfontsel x2x
     xrestop
     xclip
     chromium  firefox #google-chrome # chromiumDev
     evince xpdf gphoto2 gphoto2fs imagemagick gnumeric abiword
     # pdfmod gnome3.gconf # hack: pdfmod needed gconf, but was later broken anyway
     gimp-with-plugins
     # enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar
     audacity fldigi
     exif exiftags
     keepassxc
     (pass.withExtensions (ext: with ext; [ pass-import ]))
     browserpass
     androidsdk
     graphviz
     sshfs-fuse ansible
     lsdvd dvdbackup handbrake cdrkit
     (pidgin.override {
       plugins = [ purple-plugin-pack ];
     })

     tetex ghostscriptX
     rclone google-drive-ocamlfuse
  ];

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps, terminate:ctrl_alt_bksp, compose:ralt";
    enableCtrlAltBackspace = true;
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      default = "xmonad";
    };
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;
  programs.browserpass.enable = true;

  sound.enable = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
        terminus_font
    ];
  };
}
