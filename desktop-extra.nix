{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./desktop.nix ];

  environment.systemPackages = with pkgs; [
    # GIS
    qgis

    # SDR
    fldigi
    hackrf
    gqrx # SDR
    # https://github.com/NixOS/nixpkgs/issues/371164
    # urh # Universal Radio Hacker (SDR tool)  # Broken in unstable

    # Games
    endless-sky
    mindustry
    flightgear
    prismlauncher
    vintagestory
    # TODO: 0ad xonotic quake3 blobwars openttd gotypist gtypist gtetrinet ?
  ];

  services.keybase.enable = true;
  services.kbfs.enable = true;

  hardware.hackrf.enable = true;

}
