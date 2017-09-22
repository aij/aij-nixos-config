# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./aij/desktop.nix
      ./aij/ccap-dev.nix
      ./aij/ccap-env.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.initrd.luks.devices."nixcrypt" = {
     device = "/dev/disk/by-uuid/80687aab-261a-4ca9-aeec-6830df3308de";
  };

  networking.hostName = "altos";
  networking.hostId = "8425e349";
  networking.interfaces.enp0s31f6 = { ipAddress = "165.219.91.75"; prefixLength = 22; };
  networking.defaultGateway = "165.219.90.3";
  networking.nameservers = [ "165.219.91.41" "165.219.91.42" ];
  # Hack for CCAP3
  networking.extraHosts = ''
    127.0.1.1	altos.wicourts.gov altos
  '';

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];
  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # CCAP CIFS mounts
  fileSystems = let
    cifs = src: dst: {
      fsType = "cifs";
      device = src;
      mountPoint = dst;
      options = ["credentials=/home/aij/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0644,dir_mode=0755"];
    };
  in {
    H = cifs "//ccap-rds-1/user/staff/ijager" "/media/H";
    M = cifs "//ccap-rds-1/user/data" "/media/M";
    J = cifs "//ccap-rds-1/apps/Java" "/media/J";
    U = cifs "//ccap-rds-1/user" "/media/U";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
