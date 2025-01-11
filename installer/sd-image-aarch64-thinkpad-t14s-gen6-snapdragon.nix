# Installer for Lenovo Thinkpad T14s Gen6 Snapdragon
#
# Ref
# https://discourse.ubuntu.com/t/ubuntu-24-10-concept-snapdragon-x-elite/48800/358
# https://discourse.nixos.org/t/configuration-for-thinkpad-t14s-gen-6-snapdragon-x-elite-x1e-78-100/56389
# https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image_natively
#
# Build with
# nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=installer/sd-image-aarch64-thinkpad-t14s-gen6-snapdragon.nix -I nixpkgs=stable/
{ config, lib, pkgs, ... }:
{
  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    # Want at least kernel 6.12
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-installer.nix>
    #../standard.nix
    ../sshd.nix
  ];

  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "clk_ignore_unused"
      "pd_ignore_unused"
    ];
    kernelPatches = [
      {
        name = "snapdragon-config";
        patch = null;
        extraConfig = ''
          TYPEC y
          PHY_QCOM_QMP y
          QCOM_CLK_RPM y
          MFD_QCOM_RPM y
          REGULATOR_QCOM_RPM y
          PHY_QCOM_QMP_PCIE y
          CLK_X1E80100_CAMCC y
        '';
      }
    ];
    loader = {
      #efi.canTouchEfiVariables = true;
      #systemd-boot.enable = true;
      systemd-boot.enable = false;
      #generic-extlinux-compatible.enable = lib.mkForce false;
      grub = {
        #enable = lib.mkForce true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
  };

  hardware = {
    deviceTree = {
      enable = true;
      name = "qcom/x1e78100-lenovo-thinkpad-t14s.dtb";
    };
    enableRedistributableFirmware = true;
    # TODO: firmware = [];
  };

  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings.General.ControlPortOverNL80211 = false;

}
