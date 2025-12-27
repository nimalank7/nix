/*
nix-build greet.nix
readlink result
cat /nix/store/<hash>-greet.txt
*/

# Run nix-build hello.nix

builtins.derivation {
  name = "greet.txt";
  builder = ./greet.sh;
  system = builtins.currentSystem;

  greeting = "Hello, World!";
}