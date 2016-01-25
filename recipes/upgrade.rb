if File.directory?('/opt/chef-compliance/')
  Chef::Log.warn '*** Chef Compliance already installed, upgrading...'
  node.set['ccc']['package_url'] = node['ccc']['package2_url']
else
  Chef::Log.warn '*** Chef Compliance not installed yet'
end

include_recipe 'ccc::default'
