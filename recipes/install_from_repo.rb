compliance_server 'from-repo' do
  package_version node['ccc']['package_version']
  package_repo node['ccc']['package_repo']
  admin_user node['ccc']['initial_user']
  admin_pass node['ccc']['initial_pass']
  config node['ccc']['config'].to_hash
  action :install
end
