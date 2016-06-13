compliance_server 'from-repo' do
  package_version node['ccc']['package_version']
  package_channel node['ccc']['package_channel']
  admin_user node['ccc']['initial_user']
  admin_pass node['ccc']['initial_pass']
  config node['ccc']['config'].to_hash
  action node['ccc']['action'].to_sym
end
