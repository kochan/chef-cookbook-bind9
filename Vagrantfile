Vagrant::Config.run do |config|
  config.vm.box = "precise64_updated"
  config.vm.forward_port 53, 10053

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.add_recipe "build-essential"
    chef.add_recipe "openssl"
    chef.add_recipe "bind9"
  end
end
