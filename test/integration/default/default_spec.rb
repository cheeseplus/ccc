describe package('chef-compliance') do
  it { should be_installed }
end

describe user('chef-compliance') do
  it { should exist }
end

describe file('/opt/chef-compliance/version-manifest.txt') do
  its('content') { should match 'chef-compliance 0\.9\.\d' }
end
