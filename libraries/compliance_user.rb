# `compliance_user` custom resource to create Chef Compliance users
class ComplianceUser < Chef::Resource
  use_automatic_resource_name

  property :username, String, name_property: true
  property :password, String, required: true

  default_action :create

  action :create do
    converge_by 'Create Chef Compliance user' do
      execute 'adduser' do
        environment('USER' => username,
                    'PASS' => password)
        command <<-EOH
          chef-compliance-ctl user-create "$USER" "$PASS"
        EOH
        action :run
        only_if do
          username.is_a?(String) && username.length > 0 &&
            password.is_a?(String) && password.length > 0
        end
      end
    end
  end

  ### TODO: :remove action
end
