{ pkgs, lib, ... }: {
  # See https://nixos.wiki/wiki/Bluetooth
  # and https://wiki.archlinux.org/index.php/Bluetooth_headset
  hardware.bluetooth.enable = true;
}
