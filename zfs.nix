{ config, pkgs, ... }:
{
  # For first boot, set (or manually pass)
  # boot.kernelParams = ["zfs_force=1"];

  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
  };
  services.zfs.autoScrub.enable = true;

}
