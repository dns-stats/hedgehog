VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  config.vm.network :forwarded_port, guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network :private_network, ip: '192.168.50.50'

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.synced_folder '.', '/vagrant'

  config.vm.provision "shell", path: "provision/dependencies.sh"
  config.vm.provision "shell", path: "provision/compile.sh"
  config.vm.provision "shell", path: "provision/launch.sh"

end
