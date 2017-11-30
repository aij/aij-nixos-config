{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
     gkrellm
     gnupg kismet # openssh_with_kerberos
     xscreensaver rxvt_unicode terminus_font geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xorg.xev xorg.xmodmap xfontsel x2x
     xclip
     chromium  firefox google-chrome # chromiumDev
     evince xpdf pdfmod gphoto2 gphoto2fs imagemagick gnumeric abiword
     gnome3.gconf # hack
     gimp-with-plugins
     enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar
     audacity fldigi
     exif exiftags
     keepassx2
     androidsdk
     graphviz
     sshfs-fuse ansible
     lsdvd dvdbackup handbrake cdrkit
     (pidgin.override {
       plugins = [ purple-plugin-pack ];
     })
  ];

  services.xserver = {
    enable = true;
    layout = "dvorak";
    # services.xserver.xkbOptions = "ctrl:nocaps, terminate:ctrl_alt_bksp, compose:rwin";
    enableCtrlAltBackspace = true;
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      default = "xmonad";
    };
  };


  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
        terminus_font
    ];
  };
}
