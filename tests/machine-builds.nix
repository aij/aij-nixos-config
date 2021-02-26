{lib ? import ../unstable/lib, ...}:
let

  # aij = ../;
  machines = ../machines;
  config_files = [
    # TODO: Use readdir
    ../machines/tobati
    ../machines/belen
    ../machines/ita
    ../machines/m0
    ../machines/m1
    ../machines/m4
    ../machines/m5
    ../machines/m6
  ];
  configs = builtins.listToAttrs (map (f: {name = baseNameOf f; value = import f; }) config_files) ;
  nixes = [ ./stable ./unstable ];
  build = config: nixos:
    (import ../stable/nixos { configuration = config; }).system;
  hosts =  builtins.mapAttrs (name: conf: {unstable = build conf ./unstable; stable = build conf ./stable; }) configs;
  machine_builds = builtins.concatMap (n: [hosts.${n}.stable hosts.${n}.unstable]) (builtins.attrNames hosts);

in machine_builds
# stdenv.mkDerivation {
#   propagatedBuildInputs = machine_builds;
# }
