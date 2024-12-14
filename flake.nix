{
  inputs = {
    stable.url = "git+file:stable"; #"nixpkgs/nixos-22.05";
    unstable.url = "git+file:unstable"; #"nixpkgs/nixos-unstable-small";
  };

  outputs = { self, stable, unstable }: {
    nixosConfigurations =
      let
        mkSystemConfigs = system: m:
          let
            name = baseNameOf m;
            conf = { inherit system; modules = [ m ]; };
          in
          {
            "${name}-stable" = stable.lib.nixosSystem conf;
            "${name}-unstable" = unstable.lib.nixosSystem conf;
          };

        x64 = m: mkSystemConfigs "x86_64-linux" m;

        lib = unstable.lib;
        machines = lib.fold lib.mergeAttrs { } [
          (x64 machines/tobati)
          (x64 machines/yaguaron)
          (x64 machines/curupayty)
          (x64 ./machines/m0)
          (x64 ./machines/m1)
          (x64 ./machines/m2)
          (x64 ./machines/m4)
          (x64 ./machines/m5)
          (x64 ./machines/m6)
          (x64 ./machines/m7)
        ];

        # systemArgs = {
        #   tobati = x64 ./machines/tobati;
        # };
        # machines = nixpkgs: {
        #   tobati = nixpkgs.lib.nixosSystem { system = x64; modules = [ ./machines/tobati ]; };
        # };
        # in
        # machines unstable;
      in
      machines // (with machines; {
        tobati = tobati-unstable;
        yaguaron = yaguaron-stable;
        curupayty = curupayty-stable;
        m0 = m0-stable;
        m1 = m1-stable;
        m2 = m2-stable;
      });
  };
}
