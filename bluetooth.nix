{ pkgs, lib, ... }: {
  # See https://nixos.wiki/wiki/Bluetooth
  # and https://wiki.archlinux.org/index.php/Bluetooth_headset
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Used to be necessary for bluetooth headphones
    # Removed in  https://github.com/NixOS/nixpkgs/pull/160097
    extraModules =
      let p = builtins.tryEval pkgs.pulseaudio-modules-bt; # False after NixOS 21.11
      in
      lib.optional p.success p.value;
    package = pkgs.pulseaudioFull;
  };
  # services.blueman.enable = true;
}
