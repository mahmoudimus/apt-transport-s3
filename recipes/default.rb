#
# Cookbook Name:: apt_transport_s3
# Recipe:: default
#
# Copyright 2013, Balanced
#
# All rights reserved - Do Not Redistribute
#

# we want to install deb-s3 gem so we can modify the s3 bucket
include_recipe 'apt_transport_s3::debs3'

# install the package if the binary isn't there
unless ::File.exists?('/usr/lib/apt/methods/s3')
  # let's build the s3 transport package
  include_recipe 'apt_transport_s3::compile'
end

# we want to actually enable the apt repository
include_recipe 'apt_transport_s3::add_custom_s3_repo'


if node[:apt_transport_s3][:deb][:refresh_cache]
  # update the cache
  Chef::Log.info 'Refreshing the cache-yo'
  execute 'apt-get-update-periodic' do
    command 'apt-get update'
    ignore_failure true
    only_if do
     ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
     ::File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
    end
  end
end