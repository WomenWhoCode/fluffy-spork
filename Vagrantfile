# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
REQUIRED_PLUGINS        = %w(vagrant-vbguest vagrant-librarian-chef-nochef)

plugins_to_install = REQUIRED_PLUGINS.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing required plugins: #{plugins_to_install.join(" ")}"
  if system "vagrant plugin install #{plugins_to_install.join(" ")}"
    exec "vagrant #{ARGV.join(" ")}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"

  # Configure the virtual machine to use 1.5GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1536"]
  end

  # Use Chef Solo to provision our virtual machine
  # This installs:
  #   - Ruby: 2.4.1
  #   - Postgres: 9.6.3
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]

    # There is a bug in the ruby_rbenv cookbook, so we must downgrade Chef until its fixed
    # https://github.com/sous-chefs/ruby_rbenv/issues/162
    chef.version = "12.19.36"

    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "system::install_packages"
    chef.add_recipe "ruby_build"
    chef.add_recipe "ruby_rbenv::user"
    chef.add_recipe "ruby_rbenv::user_install"
    chef.add_recipe "vim"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::client"

    chef.json = {
      rbenv: {
        user_installs: [{
          user: "ubuntu",
          rubies: ["2.4.1"],
          global: "2.4.1",
          gems: {
          "2.4.1": [{ name: "bundler" }]
        }
        }]
      },
      system: {
        packages: {
          install: ["nodejs", "libpq-dev"]
        }
      },
      postgresql: {
        pg_hba: [{
          comment: "# Add vagrant role",
          type: "local", db: "all", user: "ubuntu", addr: nil, method: "trust"
        }],
        users: [{
          "username": "ubuntu",
          "password": "",
          "superuser": true,
          "replication": false,
          "createdb": true,
          "createrole": false,
          "inherit": false,
          "login": true
        }]
      }
    }
  end

  # Executes any special provisioning commands, like bundler or rake tasks
  config.vm.provision :shell, privileged: false, inline:<<-SHELL
    cd /vagrant
    bundler install
    bundle exec rake db:setup
  SHELL
end
