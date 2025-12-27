{ config, pkgs, ... }:

{
  # Basic home-manager configuration
  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";
  home.stateVersion = "24.11";

  # Set configuration
  programs.git = {
		enable = true;
		userName = "vagrant";
		userEmail = "vagrant@test.com";
  };

  # Add some packages to the user environment
  home.packages = with pkgs; [
    htop
    tree
  ];
}
