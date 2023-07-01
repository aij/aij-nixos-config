{ config, lib, pkgs, nodes, ... }: {
  # Cisco C24 M3
  networking.hostName = "m4";
  networking.hostId = "8425e349";
  system.stateVersion = "17.09";

  imports =
    [
      ./hardware-configuration.nix
      ../../server.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/ata-ST5000DM000-1FK178_W4J1VWW3"
    "/dev/disk/by-id/ata-HITACHI_HUA723030ALA640_YVHJJJ3A"

    # warning: this GPT partition label contains no BIOS Boot Partition; embedding won't be possible.
    # error: embedding is not possible, but this is required for cross-disk install.
    # SMKR6000S5xeN7.2 S4D082B90000K602DFFX
    # "/dev/disk/by-id/wwn-0x5000c5008e493b33"
  ];

  # Avoid dmesg errors like
  # ACPI Error: No handler for Region [POWS] (000000008ed47a71) [IPMI]
  # https://github.com/netdata/netdata/issues/2961
  boot.blacklistedKernelModules = [ "acpi_power_meter" ];
}
