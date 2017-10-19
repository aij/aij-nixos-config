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
    nix-mode
    magit          # ; Integrate git <C-x g>
    #zerodark-theme # ; Nicolas' theme
  ]) ++ (with epkgs.melpaPackages; [
    bind-key
    company
    diminish
    ensime
    #epl #? A package management library for Emacs...
    groovy-mode
    json-mode
    math-symbol-lists
    pkg-info #?
    projectile
    psc-ide
    purescript-mode
    rainbow-delimiters
    rjsx-mode
    rust-mode
    sbt-mode
    scala-mode
    smartparens
    undo-tree      # ; <C-x u> to show the undo tree
    use-package #? Remove?
    yasnippet #? Used by ?
    #zoom-frm       # ; increase/decrease font size for all buffers <C-x C-+>
  ]) ++ (with epkgs.elpaPackages; [
    #auctex         # ; LaTeX mode
    #beacon         # ; highlight my cursor when scrolling
    #nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    pkgs.notmuch   # From main packages set
  ])
