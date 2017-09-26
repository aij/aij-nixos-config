{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ./dev.nix ];

  environment.systemPackages = with pkgs; [
     gkrellm
     gnupg kismet # openssh_with_kerberos
     xscreensaver rxvt_unicode terminus_font pidgin geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xorg.xev xorg.xmodmap xfontsel x2x
     chromium  firefox google-chrome # chromiumDev
     evince gphoto2 gphoto2fs imagemagick gnumeric abiword
     enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar
     audacity fldigi
     exif exiftags
     keepassx2
     androidsdk
     sshfs-fuse
     lsdvd dvdbackup handbrake cdrkit
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
