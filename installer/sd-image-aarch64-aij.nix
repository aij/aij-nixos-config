# https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image_natively
#
# Build with
# nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=installer/sd-image-aarch64-aij.nix
{ config, lib, pkgs, ... }:
{
  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix>
    #../standard.nix
    ../sshd.nix
  ];
}
