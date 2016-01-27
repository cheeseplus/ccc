# `compliance_server` custom resource to install or upgrade the Chef Compliance software
class ComplianceServer < Chef::Resource
  use_automatic_resource_name

  property :admin_user, String
  property :admin_pass, String
  property :package_url, String
  property :config, Hash, default: {}
  property :package_repo, String, default: 'chef-stable'
  property :package_version, String, default: 'latest'

  #########
  # Actions
  #########

  default_action :install

  action :install do
    converge_by 'Install Chef Compliance' do
      if package_url
        pkgname = ::File.basename(package_url)
        cache_path = ::File.join(Chef::Config[:file_cache_path], pkgname).gsub(/~/, '-')
        Chef::Log.warn "*** Downloading Chef Compliance package '#{pkgname}' for action '#{action}'"

        remote_file cache_path do
          source package_url
          mode '0644'
          action :create
        end
      end

      case node['platform_family']
      when 'debian'
        node.default['apt-chef']['repo_name'] = package_repo
      when 'rhel'
        node.default['yum-chef']['repositoryid'] = package_repo
      end

      directory '/etc/chef-compliance' do
        recursive true
        action :create
      end

      # Can't use not_if for chef_ingredient due to the array of actions
      if action == :upgrade || !::File.exist?('/opt/chef-compliance/bin/chef-compliance-ctl')
        ### TODO: get content from config hash
        file '/etc/chef-compliance/chef-compliance.rb' do
          owner 'root'
          group 'root'
          mode '0600'
          content ''
          sensitive true
          notifies :reconfigure, 'chef_ingredient[compliance]'
          action :create
        end

        actions_array = [action, :reconfigure]

        # Install Chef Compliance package using a custom resource from the `chef-ingredient` cookbook
        chef_ingredient 'compliance' do
          # Prefer package_url if set over custom repository
          if package_url
            Chef::Log.warn "*** Using Compliance package: #{package_url}"
            package_source cache_path
          else
            Chef::Log.warn "*** Using CHEF's public repository '#{package_repo}' to install version '#{package_version}"
            version package_version
          end
          ctl_command '/opt/chef-compliance/bin/chef-compliance-ctl'
          notifies :create, "compliance_user[#{admin_user}]"
          action actions_array
        end
      end

      # Custom resource defined in this cookbook
      compliance_user admin_user do
        password admin_pass
        only_if do
          admin_user.is_a?(String) && admin_user.length > 0 &&
            admin_pass.is_a?(String) && admin_pass.length > 0
        end
        notifies :restart, 'omnibus_service[compliance/core]'
        action :nothing
      end

      # Custom resource from the `chef-ingredient` cookbook
      omnibus_service 'compliance/core' do
        action :nothing
      end
    end
  end

  action :upgrade do
    converge_by 'Upgrade Chef Compliance' do
      Chef::Log.warn "*** Upgrade Chef Compliance from #{package_url} or #{package_repo} for action #{action}"
      action_install
    end
  end

  ### TODO: :uninstall Chef Compliance
end
