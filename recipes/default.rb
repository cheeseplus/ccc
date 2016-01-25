if node['compliance_omnibus']['package_url']
  pkgname = ::File.basename(node['compliance_omnibus']['package_url'])
  cache_path = ::File.join(Chef::Config[:file_cache_path], pkgname).gsub(/~/, '-')

  # recipe
  remote_file cache_path do
    source node['compliance_omnibus']['package_url']
    mode '0644'
  end
end

case node['platform_family']
when 'debian'
  node.default['apt-chef']['repo_name'] = node['compliance_omnibus']['package_repo']
when 'rhel'
  node.default['yum-chef']['repositoryid'] = node['compliance_omnibus']['package_repo']
end

directory '/etc/chef-compliance' do
  recursive true
end

file '/etc/chef-compliance/chef-compliance.rb' do
  owner 'root'
  group 'root'
  mode '0600'
  content ''
  sensitive true
  notifies :reconfigure, 'chef_ingredient[compliance]'
end

chef_ingredient 'compliance' do
  ctl_command '/opt/chef-compliance/bin/chef-compliance-ctl'
  # Prefer package_url if set over custom repository
  if node['compliance_omnibus']['package_url']
    Chef::Log.info "Using Compliance package source: #{node['compliance_omnibus']['package_url']}"
    package_source cache_path
  else
    Chef::Log.info "Using CHEF's public repository #{node['compliance_omnibus']['package_repo']}"
    version node['compliance_omnibus']['package_version']
  end
  notifies :run, 'execute[adduser]'
end

execute 'adduser' do
  environment('INITIAL_USER' => node['compliance_omnibus']['initial_user'],
              'INITIAL_PASS' => node['compliance_omnibus']['initial_pass'])
  command <<-EOH
    chef-compliance-ctl user-create "$INITIAL_USER" "$INITIAL_PASS"
    chef-compliance-ctl restart
  EOH
  action :nothing
end
