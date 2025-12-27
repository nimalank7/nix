Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_version = "24.05"

  # Fix Vagrant startup issue
  config.vm.allow_fstab_modification = false
  
  # Sync current host directory to /vagrant in the VM
  config.vm.synced_folder ".", "/home/vagrant/shared"
end