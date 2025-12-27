/*
nix-shell shell.nix
*/

{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/0c408a087b4751c887e463e3848512c12017be25.tar.gz") {}
}:

pkgs.mkShell {
  packages = [ pkgs.go ];
}