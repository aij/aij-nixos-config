{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../standard.nix
      ../../stable.nix
      ../../sshd.nix
      ../../desktop.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_M.2_250GB_S24BNWAG403217T" ];
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "curupayty";
  networking.hostId = "10154ee4";
  networking.wireless.iwd.enable = true;

  environment.systemPackages = with pkgs; [
    tuxtype
    tuxpaint

  ];

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

