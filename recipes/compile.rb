#
# Cookbook Name:: apt_transport_s3
# Recipe:: compile
#
# Copyright 2013, Balanced
#
# All rights reserved - Do Not Redistribute
#

# install dependencies
%w(git-core build-essential libapt-pkg-dev libcurl4-openssl-dev).each do |package_name|
  package package_name  do
    action :install
    options '--force-yes'
  end
end

execute 'disable strict host key checking for git cloning' do
  command <<-EOH
    ssh -o 'StrictHostKeyChecking no' git@github.com || true
  EOH
end

directory "#{node[:apt_transport_s3][:git][:target_clone_directory]}" do
  recursive true
  action :delete
end

git "#{node[:apt_transport_s3][:git][:target_clone_directory]}" do
  repository "#{node[:apt_transport_s3][:git][:repository]}"
  action :sync
  notifies :run, 'execute[make-apt-transport-s3-binary]', :immediately
end


execute 'make-apt-transport-s3-binary' do
  cwd "#{node[:apt_transport_s3][:git][:target_clone_directory]}"
  command 'make'
  action :nothing
  notifies :run, 'execute[copy-s3-binary-to-transport-loc]', :immediately
end


execute 'copy-s3-binary-to-transport-loc' do
  only_if "#{node[:apt_transport_s3][:binary][:copy]}"
  cwd "#{node[:apt_transport_s3][:git][:target_clone_directory]}"
  command <<-EOH
     cp -p \
       #{node[:apt_transport_s3][:git][:target_clone_directory]}/src/s3 \
       #{node[:apt_transport_s3][:binary][:dest]}
  EOH
  action :nothing
end


# build debian package

if node[:apt_transport_s3][:deb][:make][:enabled]

  directory "#{node[:apt_transport_s3][:deb][:make][:location]}" do
    action :create
    not_if { ::Dir.exists?("#{node[:apt_transport_s3][:deb][:make][:location]}") }
  end

  %w(debhelper cdbs).each do |package_name|
    package package_name  do
      action :install
    end
  end

  execute 'make-apt_transport_s3-debian' do
    cwd "#{node[:apt_transport_s3][:git][:target_clone_directory]}"
    command <<-EOH
      make deb
      cd #{::File.dirname(node[:apt_transport_s3][:git][:target_clone_directory])}
      mv *.deb "#{node[:apt_transport_s3][:deb][:make][:location]}"
    EOH
  end

  # install the package locally if the binary isn't there
  package 'apt-transport-s3' do
    provider Chef::Provider::Package::Dpkg
    source %x(ls -1 #{node[:apt_transport_s3][:deb][:make][:location]}/*.deb).chomp
    action :install
    not_if { ::File.exists?('/usr/lib/apt/methods/s3') }
  end

  # upload the debian package we just built into the s3 bucket

  execute "uploading #{node[:apt_transport_s3][:deb][:name]} to s3" do
    cwd "#{node[:apt_transport_s3][:deb][:make][:location]}"
    # deb-s3 upload apt_transport_s3_1.1.1ubuntu2_amd64.deb
    #       --access-key=KEY --secret-key=SECRET
    #       --bucket=balanced.debs --endpoint=s3-us-west-1.amazonaws.com
    command <<-EOH
      deb-s3 upload apt-transport-s3_1.1.1ubuntu2_amd64.deb \
           --bucket=#{node[:apt_transport_s3][:s3][:bucket_name]} \
           --access-key=#{node[:apt_transport_s3][:s3][:access_key]} \
           --secret-key=#{node[:apt_transport_s3][:s3][:secret_key]} \
           --endpoint=#{node[:apt_transport_s3][:s3][:endpoint]}
    EOH
  end

end
