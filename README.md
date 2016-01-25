ccc Cookbook
==============================
Cookbook to install and upgrade `chef-compliance`


How to use it:
------------
Run `ccc::default` and it will install or upgrade to the Chef Compliance package specified via `node['ccc']['package_url']` or `node['ccc']['package_version']`

Run `ccc::upgrade` and it will:
* install Chef Compliance from `node['ccc']['package_url']` or `node['ccc']['package_version']` if not already installed
* upgrade Chef Compliance from `node['ccc']['package2_url']` or `node['ccc']['package2_version']` if already installed
