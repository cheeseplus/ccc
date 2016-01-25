if File.directory?('/opt/chef-compliance/')
  node.set['ccc']['package_url'] = node['ccc']['package2_url']
  node.set['ccc']['package_version'] = node['ccc']['package2_version']
  Chef::Log.warn '*** Upgrading Chef Compliance'
else
  Chef::Log.warn '*** Installing Chef Compliance'
end

include_recipe 'ccc::default'
