# frozen_string_literal: true

describe file('/etc/init.d/nginx') do
  its(:link_path) { should eq('/opt/nginx/init.d/nginx') }
end

describe file('/opt/nginx/init.d/nginx') do
  its(:owner) { should eq('root') }
  its(:group) { should eq('root') }
  its(:mode) { should cmp('0755') }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end
