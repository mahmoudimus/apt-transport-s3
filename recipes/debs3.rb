#
# Cookbook Name:: apt_transport_s3
# Recipe:: debs3
#
# Copyright 2013, Balanced
#
# All rights reserved - Do Not Redistribute
#

%w(ruby1.9.1 rubygems libxml2-dev libxslt1-dev).each do |package_name|
  package package_name do
    action :install
  end
end

# this will install ruby1.9.1 in the /usr/bin directory
# and it will also install the gem1.9.1 binary there as well

gem_package 'deb-s3' do
  version '0.5.1'
  gem_binary '/usr/bin/gem1.9.1'
  action :install
end
