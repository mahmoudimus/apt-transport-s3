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

gem_package 'deb-s3' do
  action :install
end
