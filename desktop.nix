{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  environment.systemPackages = with pkgs; [
     man-pages
     gkrellm
     gnupg kismet # openssh_with_kerberos
     xscreensaver rxvt_unicode terminus_font pidgin geeqie mplayer vlc mpv
     xorg.xinit xorg.xdpyinfo xorg.xbacklight xorg.xdriinfo xorg.xev xorg.xmodmap xfontsel x2x
     chromium  firefox google-chrome # chromiumDev
     evince gphoto2 gphoto2fs imagemagick
     enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar
     audacity fldigi
     exif exiftags
     keepassx2
     gnumake scala jdk python python3 ack clang ocamlPackages.utop # jre
     androidsdk
     rustc cargo
     sshfs-fuse
     lsdvd dvdbackup handbrake cdrkit
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
