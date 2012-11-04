#
# Cookbook Name:: bind9
# Attributes:: bind9
#
# Copyright 2012, Koichi Watanabe
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

## General
default[:bind9][:user] = "bind"
default[:bind9][:group] = "bind"

## Install Method (source or package)
default[:bind9][:install_method] = "source"

## Chroot
default[:bind9][:chroot_dir] = "/usr/local/chroot/bind"

## Source Install
default[:bind9][:version] = "9.9.2"
default[:bind9][:url] = "http://ftp.isc.org/isc/bind9/#{node[:bind9][:version]}/bind-#{node[:bind9][:version]}.tar.gz"

default[:bind9][:install_path] = "/usr/local/bind-#{node[:bind9][:version]}"
default[:bind9][:conf_dir] = "#{node[:bind9][:install_path]}/etc"
default[:bind9][:localstate_dir] = "/var/run/bind"
default[:bind9][:openssl_dir] = "/usr"
default[:bind9][:gssapi_dir] = "/usr"
default[:bind9][:pid] = "/var/run/bind/bind9.pid"

#default[:bind9][:cflags] = "-O2"
#default[:bind9][:ld_library_path] = "/lib:/usr/lib:/usr/local/lib"
#default[:bind9][:library_path] = "/lib:/usr/lib:/usr/local/lib"
default[:bind9][:configure_flags] = [
  "--prefix=#{node[:bind9][:install_path]}",
  "--mandir=#{node[:bind9][:install_path]}/share/man",
  "--infodir=#{node[:bind9][:install_path]}/share/info",
  "--sysconfdir=#{node[:bind9][:conf_dir]}",
  "--localstatedir=#{node[:bind9][:localstate_dir]}",
  "--enable-threads",
  "--enable-largefile",
  "--with-libtool",
  "--enable-shared",
  "--enable-static",
  "--with-openssl=#{node[:bind9][:openssl_dir]}",
  "--with-gssapi=#{node[:bind9][:gssapi_dir]}",
  "--with-gnu-ld",
#  "--with-dlz-postgres=no",
#  "--with-dlz-mysql=no",
#  "--with-dlz-bdb=yes",
  "--with-dlopen=yes",
  "--with-dlz-filesystem=yes",
#  "--with-dlz-ldap=yes",
#  "--with-dlz-stub=yes",
  "--enable-ipv6"
]
