{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  environment.systemPackages = with pkgs; [
     man-pages
     gkrellm
     gnupg kismet # openssh_with_kerberos
     xscreensaver rxvt_unicode terminus_font pidgin geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xfontsel x2x
     chromium  firefox google-chrome # chromiumDev
     evince gphoto2 gphoto2fs
     enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar
     audacity fldigi
     exif exiftags
     keepassx2
     gnumake scala jdk python python3 ack clang ocamlPackages.utop # jre
     androidsdk
     lsdvd dvdbackup handbrake      
  ];


  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
        terminus_font
    ];
  };

} 
