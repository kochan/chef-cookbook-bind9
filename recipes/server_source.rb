#
# Cookbook Name:: bind9
# Recipe:: default
#
# Copyright 2012, Koichi Watanabe
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"
include_recipe "openssl"

packages = ['libkrb5-dev', 'libssl-dev', 'libtool']

packages.each do |p|
  package p
end

directory node[:bind9][:chroot_dir] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

bash "compile_bind9_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf bind-#{node[:bind9][:version]}.tar.gz
    (cd bind-#{node[:bind9][:version]} && ./configure #{node[:bind9][:configure_flags].join(" ")})
    (cd bind-#{node[:bind9][:version]} && make && make install)
  EOH
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/bind-#{node[:bind9][:version]}.tar.gz" do
  source "#{node[:bind9][:url]}"
  action :create_if_missing
  not_if "test -d #{node[:bind9][:install_path]}"
  notifies :run, "bash[compile_bind9_source]", :immediately
end

%w{dev etc/named var/log var/run}.each do |dir|
  directory "#{node[:bind9][:chroot_dir]}/#{dir}" do
    mode "0775"
    owner node[:bind9][:user]
    group node[:bind9][:group]
    action :create
    recursive true
  end
end

execute "ensure_dev_null" do
  creates "#{node[:bind9][:chroot_dir]}/dev/null"
  command "mknod #{node[:bind9][:chroot_dir]}/dev/null c 1 3"
end

execute "ensure_dev_zero" do
  creates "#{node[:bind9][:chroot_dir]}/dev/zero"
  command "mknod #{node[:bind9][:chroot_dir]}/dev/zero c 1 5"
end

execute "ensure_dev_random" do
  creates "#{node[:bind9][:chroot_dir]}/dev/random"
  command "mknod #{node[:bind9][:chroot_dir]}/dev/random c 1 8"
end

execute "ensure_dev_random" do
  creates "#{node[:bind9][:chroot_dir]}/etc/localtime"
  command "cp -pi /etc/localtime #{node[:bind9][:chroot_dir]}/etc/localtime"
end

execute "ensure_libgost.so" do
  creates "#{node[:bind9][:chroot_dir]}/usr/lib/x86_64-linux-gnu/openssl-1.0.0/engines/libgost.so"
  command "cp -pi /usr/lib/x86_64-linux-gnu/openssl-1.0.0/engines/libgost.so  #{node[:bind9][:chroot_dir]}/usr/lib/x86_64-linux-gnu/openssl-1.0.0/engines/libgost.so"
end

remote_directory "#{node[:bind9][:chroot_dir]}/etc/named/master" do
  source "master"
  files_owner node[:bind9][:user]
  files_group node[:bind9][:group]
  files_mode "0644"
  owner node[:bind9][:user]
  group node[:bind9][:group]
  mode "0755"
end

template "#{node[:bind9][:chroot_dir]}/etc/named/named.conf" do
  source "named.conf.erb"
  owner node[:bind9][:user]
  group node[:bind9][:group]
  mode "0600"
  action :create
end

template "#{node[:bind9][:chroot_dir]}/etc/named/rndc.key" do
  source "rndc.key.erb"
  owner node[:bind9][:user]
  group node[:bind9][:group]
  mode "0600"
  action :create
end

link "/etc/named" do
  to "#{node[:bind9][:chroot_dir]}/etc/named"
  action :create
end

#service "bind9" do
#  provider Chef::Provider::Service::Upstart
#  supports :start => true, :stop => true, :restart => true
#  action [ :start, :enable ]
#end

