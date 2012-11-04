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

user node[:bind9][:user] do
  system true
  shell "/bin/false"
  home "#{node[:bind9][:install_path]}"
end

group node[:bind9][:group] do
  system true
  members node[:bind9][:user]
end

#template "bind9" do
#  path "/etc/init/bind9.conf"
#  source "bind9.conf.erb"
#  owner "root"
#  group "root"
#  mode "0755"
#end

if node[:bind9][:install_method] = "source"
  include_recipe "bind9::server_source"
elsif node[:bind9][:install_method] = "package"
  include_recipe "bind9::server_package"
end
