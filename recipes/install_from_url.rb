compliance_server 'from-url' do
  package_url node['ccc']['package_url']
  config node['ccc']['config'].to_hash
  admin_user node['ccc']['initial_user']
  admin_pass node['ccc']['initial_pass']
  action node['ccc']['action'].to_sym
end
