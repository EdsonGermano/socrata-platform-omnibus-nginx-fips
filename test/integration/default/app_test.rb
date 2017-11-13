# frozen_string_literal: true

describe package('nginx') do
  it { should be_installed }
end

describe directory('/opt/nginx') do
  its(:owner) { should eq('root') }
  its(:group) { should eq('root') }
  its(:mode) { should cmp('0755') }
end
