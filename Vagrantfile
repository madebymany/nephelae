# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.define :precise64 do |precise64|
    precise64.vm.box = "precise64"
    precise64.vm.box_url = "http://files.vagrantup.com/precise64.box"
    precise64.vm.network :bridged, :bridge => "en0"
    precise64.vm.customize ["modifyvm", :id, "--memory", 512]
    precise64.vm.share_folder "v-data", "/nephelae", "./"
  end

end
