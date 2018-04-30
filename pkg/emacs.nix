/*
From https://nixos.org/nixos/manual/index.html#idm140737315628272
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> {} }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    dumb-jump
    go-mode
    groovy-mode
    json-mode
    magit          # ; Integrate git <C-x g>
    markdown-mode
    math-symbol-lists
    projectile
    rainbow-delimiters
    rust-mode
    sbt-mode
    scala-mode
    smartparens
    use-package # Useful for package configuration, even when they are installed via nix.
    yaml-mode
    #zerodark-theme # ; Nicolas' theme
  ]) ++ (with epkgs.melpaPackages; [
    ensime
    nix-mode
    prettier-js
    psc-ide
    purescript-mode
    rjsx-mode
    undo-tree      # ; <C-x u> to show the undo tree
    web-mode
    #zoom-frm       # ; increase/decrease font size for all buffers <C-x C-+>
  ]) ++ (with epkgs.elpaPackages; [
    #auctex         # ; LaTeX mode
    #beacon         # ; highlight my cursor when scrolling
    #nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    #pkgs.notmuch   # From main packages set
  ])
