#
# Cookbook Name:: apt_transport_s3
# Recipe:: default
#
# Copyright 2013, Balanced
#
# All rights reserved - Do Not Redistribute
#

node.default[:apt_transport_s3][:binary][:copy] = false
node.default[:apt_transport_s3][:binary][:dest] = '/usr/lib/apt/methods/s3'

node.default[:apt_transport_s3][:git][:target_clone_directory] = '/tmp/apt-s3'
node.default[:apt_transport_s3][:git][:repository] = 'https://github.com/castlabs/apt-s3.git'

node.default[:apt_transport_s3][:deb][:make][:enabled] = true
node.default[:apt_transport_s3][:deb][:make][:location] = '/tmp/repos'
node.default[:apt_transport_s3][:deb][:name] = 'apt-transport-s3'
node.default[:apt_transport_s3][:deb][:refresh_cache] = true

node.default[:apt_transport_s3][:s3][:endpoint] = 's3-us-west-1.amazonaws.com'
node.default[:apt_transport_s3][:s3][:bucket_name] = 'balanced.debs'
# XXX: Fill these in with read/write credentials.
node.default[:apt_transport_s3][:s3][:access_key] = nil
node.default[:apt_transport_s3][:s3][:secret_key] = nil