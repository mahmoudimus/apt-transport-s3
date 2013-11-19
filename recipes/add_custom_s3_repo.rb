#
# Cookbook Name:: apt_transport_s3
# Recipe:: add_custom_s3_repo
#
# Copyright 2013, Balanced
#
# All rights reserved - Do Not Redistribute
#

apt_repository "#{node[:apt_transport_s3][:deb][:name]}" do
  # The brackets for the secret key are not indicating that the secret key is
  # optional, you need to include the brackets. They are there to disambiguate
  # the secret key if any characters show up that confuse things.
  #
  # - http://skife.org/apt/aws/2012/10/12/private-apt-repos-in-s3.html
  uri [
          's3://',
          "#{node[:apt_transport_s3][:s3][:access_key]}",
          ":[#{node[:apt_transport_s3][:s3][:secret_key]}]",
          "@#{node[:apt_transport_s3][:s3][:endpoint]}",
          "/#{node[:apt_transport_s3][:s3][:bucket_name]}"
      ].join
  distribution 'stable'
  components %w(main)
  Chef::Log.info("Balanced Debian Packages: #{uri} #{distribution} #{components}")
  action :add
end



