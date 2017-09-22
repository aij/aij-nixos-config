# Configuration for NixOS systems running at CCAP
{ config, pkgs, ... }:
{
  networking.domain = "wicourts.gov";
  networking.timeServers = ["ntp.wicourts.gov"];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi = { enable = true; nssmdns = true; };
  # Go to localhost:631, click Administration -> "Find new printers"
  # (HP LaserJet P4015 [2402B5]) is in the hallway
  # (HP LaserJet P4015 [1B42F3]) is near the kitchen
  # Is there a way to add these configurations declaratively?
}
