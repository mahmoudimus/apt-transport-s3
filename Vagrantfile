# -*- mode: ruby -*-
# vi: set ft=ruby :

# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path('../.cache', __FILE__)
guest_cache_path = '/tmp/vagrant-cache'
confucius_root = ENV['CONFUCIUS_ROOT']

unless confucius_root
  warn "[\e[1m\e[31mERROR\e[0m]: Please set the 'CONFUCIUS_ROOT' " +
       'environment variable to point to the confucius repo'
  exit 1
end

::Dir.mkdir(host_cache_path) unless ::Dir.exist?(host_cache_path)

default = {
  :user => ENV['OPSCODE_USER'] || ENV['USER'],
  :project => File.basename(Dir.getwd),

  # AWS stuff
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :keypair => ENV["AWS_USER_KEYPAIR"],
  :ami => "ami-734c6936",
  :region => "us-west-1",
  :instance_type => "m1.medium"
}

VM_NODENAME = "vagrant-#{default[:user]}-#{default[:project]}"

Vagrant.configure("2") do |config|

  config.berkshelf.enable = true
  config.chef_zero.chef_repo_path = "../../"

  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.hostname = 'localhost'

  config.omnibus.chef_version = :latest

  # ssh
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb, override|
    # Give enough horsepower to build without taking all day.
    vb.customize [
                  "modifyvm", :id,
                  "--memory", "2048",
                  "--cpus", "2",
                 ]

    config.vm.synced_folder host_cache_path, guest_cache_path
    config.vm.network :forwarded_port, host: 4567, guest: 80, auto_correct: true

  end

  config.vm.provider :aws do |aws, override|
    # override the vm boxes and the urls for AWS provider
    override.vm.box = "dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    aws.access_key_id = "#{default[:access_key_id]}"
    aws.secret_access_key = "#{default[:secret_access_key]}"
    aws.ami = "#{default[:ami]}"
    aws.region = "#{default[:region]}"
    aws.instance_type = "#{default[:instance_type]}"
    aws.keypair_name = "#{default[:keypair]}"
    aws.tags = {
      'Name' => config.vm.hostname
    }

    # Disables tty for sudo access since Amazon Linux has tty enabled by default
    # This still might fail though since Vagrant might run it's rsync command before
    # cloud-init starts.
    #
    # If it does fail you'll get a message that says:
    #
    #      The following SSH command responded with a non-zero exit status.
    #      Vagrant assumes that this means the command failed!
    #
    #      mkdir -p '/vagrant'
    #
    #      Stdout from the command:
    #
    #
    #
    #      Stderr from the command:
    #
    #      sudo: sorry, you must have a tty to run sudo
    #
    # See:
    # - https://github.com/mitchellh/vagrant-aws/issues/72
    # - https://github.com/mitchellh/vagrant-aws/issues/83
    # - http://stackoverflow.com/questions/17413598/vagrant-rsync-error-before-provisioning
    #
    # The solution (even if this fails) is to just run `vagrant provision` again
    aws.user_data = <<EOF
#!/bin/bash
echo 'Defaults:root,ec2-user !requiretty' > /etc/sudoers.d/999-vagrant-cloud-init-requiretty
chmod 440 /etc/sudoers.d/999-vagrant-cloud-init-requiretty
EOF

    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = "#{ENV['AWS_HOME']}/#{default[:keypair]}.pem"
  end

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.data_bags_path = "#{confucius_root}/data_bags"

    _s3_keys = JSON.load(File.new("#{chef.data_bags_path}/aws/s3.json"))

    chef.json = {
        :apt_transport_s3 => {
            :s3 => {
                :access_key => _s3_keys['aws_access_key_id'],
                :secret_key => _s3_keys['aws_secret_access_key']
            }
        }
    }
    chef.run_list = [
      'recipe[apt]',
      'recipe[apt_transport_s3]'
    ]
  end



end

