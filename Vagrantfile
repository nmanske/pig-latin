# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "alexgleason/elementaryos-freya64"

  config.vm.provision "shell", inline: <<-SHELL
    apt-add-repository -s -y ppa:alexgleason/pig-latin
    apt-get update
    apt-get build-dep -y pig-latin
    apt-get install -y libgtksourceview-3.0-dev
  SHELL

end
