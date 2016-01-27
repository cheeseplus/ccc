# Specify a URL to the package to install. Take precedence over `package_version`
default['ccc']['package_url'] = nil

# Specify the package version to install from CHEF's public repo
default['ccc']['package_version'] = 'latest'
default['ccc']['package_repo'] = 'chef-stable'

# Attributes required for the initial user creation
default['ccc']['initial_user'] = nil
default['ccc']['initial_pass'] = nil

default['ccc']['config'] = {}
