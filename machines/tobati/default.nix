{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../zfs.nix
    ../../desktop.nix
    ../../dev.nix
    # ../../profiles/miner.nix
  ];

  networking.hostName = "tobati";
  #networking.hostId = "235d6160";
  networking.hostId = "a638cdd5";

  networking.hosts = (import ../../hosts-home.nix).networking.hosts;

  services.openssh.enable = true;

  services.xserver = {
    videoDrivers = [ "amdgpu" "modesetting" ];
    xrandrHeads = [
      { output = "HDMI-A-0";
        monitorConfig = ''
          Option "Primary" "true"
        ''; }
      { output = "DisplayPort-2";
        monitorConfig = ''
          Option "RightOf" "HDMI-A-0"
        ''; }
    ];
  };
  boot.kernelPackages = pkgs.linuxPackages_5_3;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.memtest86.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "19.03"; # Did you read the comment?

  nixpkgs.overlays = [
    (self: super: {
      # The "firmware-linux-nonfree: 20181017 -> 20181213" upgrade causes crashing on boot.
      # (nixos/nixpkgs@374a672424f9407ac5c3f66578e42b7fa8775c34)
      # I suspect https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=ec4b0cd394472ee1491df6ef5f215d1f0953f836
      firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (oldAttrs: {
        version = "2018-10-17";
        src = pkgs.fetchgit {
          url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
          rev = "de9cefa74bba6fce3834144460868a468b8818f2";
          sha256 = "101j4jk3ixl8r3mxbkcrr5ybhb44ij3l52js4dqfxpylpiaw2cgk";
        };
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "1ndwp9yhpmx0kzayddy9i93mpv3d8gxypqm85069ic13lrjz1gdf";
        });
    })
  ];

}
