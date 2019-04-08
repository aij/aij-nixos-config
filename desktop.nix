{ config, pkgs, nixpkgs, ... }:
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
     thunderbird
     evince xpdf gphoto2 gphoto2fs imagemagick gnumeric abiword
     # pdfmod gnome3.gconf # hack: pdfmod needed gconf, but was later broken anyway
     gimp-with-plugins inkscape
     # enlightenment.rage enlightenment.terminology
     trayer haskellPackages.xmobar # TODO: Remove after fully switching to taffybar.
     # taffybar Broken in unstable :(
     audacity fldigi
     exif exiftags
     keepassxc
     (pass.withExtensions (ext: with ext; [ pass-import ]))
     browserpass
     # androidsdk TODO: Where'd it go?
     graphviz
     sshfs-fuse ansible
     lsdvd dvdbackup handbrake cdrkit
     (pidgin.override {
       plugins = [ purple-plugin-pack ];
     })

     tetex ghostscriptX
     rclone google-drive-ocamlfuse
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbOptions = "ctrl:nocaps, terminate:ctrl_alt_bksp, compose:ralt";
    enableCtrlAltBackspace = true;
    windowManager = {
      default = "xmonad";
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
