if node['ccc']['package_url']
  pkgname = ::File.basename(node['ccc']['package_url'])
  cache_path = ::File.join(Chef::Config[:file_cache_path], pkgname).gsub(/~/, '-')

  Chef::Log.warn "*** Downloading Chef Compliance package '#{pkgname}'"

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

# Install Chef Compliance
chef_ingredient 'compliance' do
  ctl_command '/opt/chef-compliance/bin/chef-compliance-ctl'
  # Prefer package_url if set over custom repository
  if node['ccc']['package_url']
    Chef::Log.warn "*** Using Compliance package source: #{node['ccc']['package_url']}"
    package_source cache_path
  else
    Chef::Log.warn "*** Using CHEF's public repository '#{node['ccc']['package_repo']}' to install version '#{node['ccc']['package_version']}'"
    version node['ccc']['package_version']
  end
  action [node['ccc']['action'], :reconfigure]
  notifies :run, 'execute[adduser]'
end

# Raise an error if the initial user attributes are not set
%w( initial_user initial_pass ).each do |attr|
  unless node['ccc'][attr].is_a?(String) && node['ccc'][attr].length>0
    raise "You did not set the a value for node['ccc']['#{attr}']!"
  end
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
