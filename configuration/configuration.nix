{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-builder.nix
      ./bootloader.nix
      ./vagrant.nix
      ./custom-configuration.nix
      # Imports our dummy module
      ./modules
    ];

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.extraConfig =
    ''
      PubkeyAcceptedKeyTypes +ssh-rsa
    '';
  
  # Invoke the dummy module
  services.dummy.enable = true;
  services.dummy.message = "Hello from configuration.nix";

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Packages for Vagrant
  environment.systemPackages = with pkgs; [
    git
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync
    vim
  ];

  users.users.root = { password = "vagrant"; };
  # Creates a "vagrant" group & user with password-less sudo access
  users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };
  users.users.vagrant = {
    description     = "Vagrant User";
    name            = "vagrant";
    group           = "vagrant";
    extraGroups     = [ "users" "wheel" ];
    password        = "vagrant";
    home            = "/home/vagrant";
    createHome      = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    ];
    isNormalUser = true;
  };

  security.sudo.extraConfig =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

}
