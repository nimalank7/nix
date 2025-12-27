# Nix
## Overview

Repository contains:
- Nix shell
- Nix packages
- NixOS configuration

`bootloader.nix`, `hardware-builder.nix`, `vagrant-hostname.nix`, `vagrant-network.nix` and `vagrant.nix` are used by Vagrant and aren't relevant to NixOS in general. `sample-configuration.nix` is a dummy `configuration.nix` file and isn't used by the Vagrant setup. It adds `ryan` as a user and enables the OpenSSH daemon.

Nix configuration:
- `configuration.nix` is what sets up the NixOS configuration
- `home.nix` is used by Home Manager to configure Git and install `htop` and `tree` for our `vagrant` user
- `flake.nix` is our Flake file
- `fake.lock` is our Flake lock file
- `dummy-nix` module installs the `hello` package and exports a systemd service `dummy` service that is used in `configuration.nix` via the `default.nix` file

`flake.nix` pins `nixpkgs` to `24.11` because the later version causes builds to [fail](https://discourse.nixos.org/t/issue-building-linux-kernel-modules-after-flake-update/62322/1)

## How to run Vagrant:

The examples here use Vagrant so run:

```
vagrant up && vagrant ssh
```

### Install packages via Nix Shell

To install the packages in `shell.nix` run the following commands:

```
cd /shared
nix-shell shell.nix
go version
```

This installs Go. To exit the nix shell run `exit`

### Build Nix packages

Nix packages to build:
- `greet.nix`
- `greeter-script.nix`
- `gnu-hello.nix`

1. To build `greet.nix`

`greet.nix`'s build script is `greet.sh`

```
nix-build greet.nix
readlink result
cat /nix/store/<hash>-greet.txt
```

2. To build `greeter-script.nix`

`greeter-script.nix`'s build script is `build-greeter-script.sh`

```
nix-build greeter-script.nix
readlink result
cat result/bin/greeter
result/bin/greeter
```

3. To build `gnu-hello.nix`

```
nix-build gnu-hello.nix
readlink result
cat result/bin/gnu-hello
result/bin/hello --version
```

### NixOS

To ensure our system configuration is brought up to the state as defined in `configuration.nix` we trigger a NixOS rebuild using our Flake file:

```
cd /home/vagrant/shared/configuration
sudo nixos-rebuild switch --flake /home/vagrant/shared/configuration#nixbox
```

To check the status of our `dummy` service we run:

```
systemctl status dummy
```

To check the git configuration we run:

```
git config --system --list
```

Since we are using Flakes we don't need to run:

```
sudo nixos-rebuild switch -I nixos-config=/home/vagrant/shared/configuration/configuration.nix
```