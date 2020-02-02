{ config, lib, pkgs, nodes, ... }: {
  # Cisco C220, 2x E5-2620
  networking.hostName = "m1"; # Formerly lff
  networking.hostId = "089eebf7";
  system.stateVersion = "17.03";

  imports =
    [ ./hardware-configuration.nix
      ../../zfs.nix
      ../../nixops.nix
    ];
}
