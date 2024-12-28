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
    # urh # Universal Radio Hacker (SDR tool)  # Broken in unstable

    # Games
    endless-sky
    mindustry
    flightgear
    prismlauncher
    # TODO: 0ad xonotic quake3 blobwars openttd gotypist gtypist gtetrinet ?
  ];

  services.keybase.enable = true;
  services.kbfs.enable = true;

  hardware.hackrf.enable = true;

}
