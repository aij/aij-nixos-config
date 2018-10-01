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
  # RICOH Aficio MP 5002 0026736F58DB is in the 10th floor hallway, left as you
  # come out of the elevators. PPD can be downloaded from
  # http://www.openprinting.org/printer/Ricoh/Ricoh-Aficio_MP_5002
  # Is there a way to add these configurations declaratively?
}
