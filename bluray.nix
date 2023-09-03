{
  # Per https://github.com/NixOS/nixpkgs/issues/63641#issuecomment-504631235
  nixpkgs.overlays = [
    (
      self: super: {
        libbluray = super.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      }
    )
  ];
}
