# https://nixos.org/nixos/manual/index.html#sec-building-cd
# Build with
# cd nixpkgs/nixos
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=installer/installation-cd-aij.nix
# Since this file imports from <nixpkgs> be sure to set nixpkgs when not using the default.
# Eg:
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=installer/installation-cd-aij.nix -I nixpkgs=/etc/nixos/aij/stable/
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
      ../standard.nix
    ];

  boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs.enableUnstable = true;
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  services.openssh.enable = true;

  # Don't stall sshd.
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTGD3FImr4dsW6pmGT5muMDjEoOTPMxxvhwWMMyAcpC ivan@tobati"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORLMYgWkpO8Psfx9cI/kLtgrxo7M4sbgBL/4wNKQDvL ivan@ita"
  ];
  # For the Mac Pro
  #networking.enableB43Firmware = true;
  #nixpkgs.config.allowUnfree = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.wireless.networks = {
  #  "linksys" = {};
  #};

  # For laptops that don't have (usable) ethernet
  networking.wireless.iwd.enable = true; # Enables wireless support via iwd / iwctl
  networking.wireless.enable = false;

  # Extra packages for hardware support
  environment.systemPackages = with pkgs; [
    # hpssacli # HP SmartArray configuration tool
    megacli # LSI/Broadcom MegaRaid configuration tool
  ];
  hardware.raid.HPSmartArray.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays =
    # Originally for Tobati. I think no longer necessary.
    lib.optional false (self: super: {
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
    });

}
