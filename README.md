Description
===========

This cookbook provides BIND9 installation/configuration in chroot jail for Ubuntu.
By default, the cookbook will compile the source of bind9.


Requirements
============

## Platforms

* Ubuntu

Tested on:

* Ubuntu 12.04

## Cookboooks

Requires Opscode's `build-essential` and `openssl` cookbook.


Attributes
==========

* `node[:bind9][:install_method]` - type of installation, `source` or `package`.

* `node[:bind9][:chroot_dir]` - root directory for a chroot jail

* `node[:bind9][:version]` - version of bind9 to install

* `node[:bind9][:install_path]` - prefix for bind9 compilation

* `node[:bind9][:configure_flags]` - configure options


Usage
==========

By default, just add to a run_list `recipe[bind9]`.


License and Author
==================

Author:: Koichi Watanabe (<koichi.watanabe.jp@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
