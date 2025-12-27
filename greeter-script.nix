/*
nix-build greeter-script.nix
readlink result
cat result/bin/greeter
result/bin/greeter
*/

let pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/ae8bdd2de4c23b239b5a771501641d2ef5e027d0.tar.gz") {};
in

builtins.derivation {
  name = "greeter";
  builder = ./build-greeter-script.sh;
  system = builtins.currentSystem;

  greeting = "Hello, World!";
  
  # This is needed as the script relies on mkdir which is part of GNU coreutils
  PATH = "${pkgs.coreutils}/bin";
}