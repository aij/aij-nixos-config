{pkgs, ...}: {
  # See https://nixos.wiki/wiki/Bluetooth
  # and https://wiki.archlinux.org/index.php/Bluetooth_headset
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
  # services.blueman.enable = true;
}
