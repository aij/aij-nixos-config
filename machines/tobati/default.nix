{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../zfs.nix
    ../../desktop-extra.nix
    ../../dev.nix
    ../../bluray.nix
    ../../hosts-home.nix
    # ../../latencytop.nix
    ../../unstable.nix
    # ../../profiles/miner.nix
  ];

  networking.hostName = "tobati";
  networking.hostId = "bd5a2ab5";


  networking.firewall = {
    allowedTCPPorts = [
      24800 # Default port for barrier
      25565 # Default port for Minecraft
      42424
    ];
    allowedUDPPorts = [
      25565
      42424
    ];
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # Not using eno1 currently but this ensures I have dhcpcd available if needed.
  #networking.interfaces.eno1.useDHCP = true;

  #networking.interfaces.enp5s0.useDHCP = true;
  # Static IP set via hosts-home.nix
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" "8.8.8.8" "4.4.4.4" ];

  # environment.systemPackages = with pkgs; [
  #   ceph # broken in unstable
  # ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  services.xserver = {
    videoDrivers = [ "amdgpu" "modesetting" ];
    xrandrHeads = [
      {
        output = "DisplayPort-2";
        monitorConfig = ''
          Option "Primary" "true"
          # Size extracted from xrandr. This really shouldn't need to be configured.
          # Unfortunately, setting the size explicitly causes Xorg to
          # miscalculate double the DPI in one dimension and casuse Firefox
          # to render everything bigger than ideal.
          # DisplaySize 697 392
        '';
      }
      {
        output = "DisplayPort-1";
        monitorConfig = ''
          Option "RightOf" "DisplayPort-2"
          # DisplaySize 697 392
        '';
      }
    ];
  };
  # Enable SI support for W5000 with AMDGPU, per
  # https://wiki.archlinux.org/index.php/AMDGPU#Enable_Southern_Islands_(SI)_and_Sea_Islands_(CIK)_support
  boot.extraModprobeConfig = ''
    options amdgpu si_support=1
    options amdgpu cik_support=0
  '';

  boot.tmp.useTmpfs = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.mirroredBoots = [
    { path = "/boot2"; devices = [ "/dev/disk/by-id/nvme-SAMSUNG_MZQLW3T8HMLP-00003_S2UDNX0J100330" ]; }
    { path = "/boot3"; devices = [ "/dev/disk/by-id/nvme-SAMSUNG_MZQLW3T8HMLP-00003_S2UDNX0J401690" ]; }
  ];

  fileSystems."/media/sr0" = {
    device = "/dev/sr0";
    #fsType = "auto";
    options = [ "defaults" "user" "ro" "utf8" "noauto" "umask=000" ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    nrBuildUsers = 56;
    # Don't build big-parallel jobs locally
    # systemFeatures = [ "nixos-test" "benchmark" "kvm" ];
    # distributedBuilds = true;
    buildMachines =
      let
        m = hostName: maxJobs: speedFactor: {
          hostName = hostName;
          maxJobs = maxJobs;
          speedFactor = speedFactor;
          sshUser = "bob";
          system = "x86_64-linux";
          supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        };
      in
      [
        #(m "m0" 32 2.6)
        #(m "m4" 32 1.8)
        (m "m5" 64 2)
        (m "m6" 64 2)
      ];
  };

  services.borgbackup.jobs = {
    m2Backup = {
      paths = [ "/home" ];
      exclude = [
        "**.cache"
        "*/tmp"
        # Common CMake out-of-tree build paths
        "*/build/"
        # kbfs default mountpoint
        "*/keybase/"
        # Avoid recursing into ZFS snapshot mountpoints
        "*/.zfs/"
      ];
      doInit = false;
      repo = "borg@m2.net0:/tank/borgbackup/tobati";
      encryption = {
        mode = "repokey";
        passCommand = "cat /root/keys/borgbackup_tobati_m2";
      };
      compression = "auto,lzma";
      startAt = "daily";
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}
