# `compliance_user` custom resource to create Chef Compliance users
class ComplianceUser < Chef::Resource
  use_automatic_resource_name

  property :username, String, name_property: true
  property :password, String, required: true

  default_action :create

  action :create do
    converge_by 'Create Chef Compliance user' do
      execute 'adduser' do
        environment('USER' => new_resource.username,
                    'PASS' => new_resource.password)
        command <<-EOH
          chef-compliance-ctl user-create "$USER" "$PASS"
        EOH
        action :run
        only_if do
          new_resource.username.is_a?(String) && new_resource.username.length > 0 &&
            new_resource.password.is_a?(String) && new_resource.password.length > 0
        end
      end
    end
  end

  ### TODO: :remove action
end
