{ config, lib, pkgs, nodes, ... }: {
  # Cisco C240, 2x E5-2650v2
  networking.hostName = "m0"; # Formerly "c240-0";
  networking.hostId = "a2853a4d";
  system.stateVersion = "18.03";

  imports =
    [
      ./hardware-configuration.nix
      ../../server.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    #efiInstallAsRemovable = true;
    device = "nodev";
    #device = "/dev/disk/by-id/ata-ST4000LM024-2AN17V_WCK0WHYR-part2";
  };

  # Avoid dmesg errors like
  # ACPI Error: No handler for Region [POWS] (000000008ed47a71) [IPMI]
  # https://github.com/netdata/netdata/issues/2961
  boot.blacklistedKernelModules = [ "acpi_power_meter" ];
}
