if node['ccc']['package_url']
  pkgname = ::File.basename(node['ccc']['package_url'])
  cache_path = ::File.join(Chef::Config[:file_cache_path], pkgname).gsub(/~/, '-')

  # recipe
  remote_file cache_path do
    source node['ccc']['package_url']
    mode '0644'
    action :create
  end
end

case node['platform_family']
when 'debian'
  node.default['apt-chef']['repo_name'] = node['ccc']['package_repo']
when 'rhel'
  node.default['yum-chef']['repositoryid'] = node['ccc']['package_repo']
end

directory '/etc/chef-compliance' do
  recursive true
  action :create
end

file '/etc/chef-compliance/chef-compliance.rb' do
  owner 'root'
  group 'root'
  mode '0600'
  content ''
  sensitive true
  action :create
  notifies :reconfigure, 'chef_ingredient[compliance]'
end

chef_ingredient 'compliance' do
  ctl_command '/opt/chef-compliance/bin/chef-compliance-ctl'
  # Prefer package_url if set over custom repository
  if node['ccc']['package_url']
    Chef::Log.info "*** Using Compliance package source: #{node['ccc']['package_url']}"
    package_source cache_path
  else
    Chef::Log.info "*** Using CHEF's public repository #{node['ccc']['package_repo']}"
    version node['ccc']['package_version']
  end
  action [:install, :reconfigure]
  notifies :run, 'execute[adduser]'
end

execute 'adduser' do
  environment('INITIAL_USER' => node['ccc']['initial_user'],
              'INITIAL_PASS' => node['ccc']['initial_pass'])
  command <<-EOH
    chef-compliance-ctl user-create "$INITIAL_USER" "$INITIAL_PASS"
    chef-compliance-ctl restart
  EOH
  action :nothing
end
