{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./desktop.nix ];


  services.xserver = {
    xkb = {
      layout = "us";
      variant = lib.mkForce "";
      options = lib.mkForce "terminate:ctrl_alt_bksp, compose:ralt";
    };
    autoRepeatDelay = lib.mkForce null;
    autoRepeatInterval = lib.mkForce null;

    desktopManager.mate.enable = true;
    displayManager.gdm.enable = true;
    displayManager.defaultSession = lib.mkForce "mate";
  };

  environment.systemPackages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/issues/371170
    # tuxtype # Broken in unstable
    tuxpaint
    gcompris
    prismlauncher
    krita
  ];
}
