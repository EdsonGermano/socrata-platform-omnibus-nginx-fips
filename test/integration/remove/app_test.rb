# frozen_string_literal: true

describe package('nginx') do
  it { should_not be_installed }
end

describe file('/usr/sbin/nginx') do
  it { should_not exist }
end

describe directory('/opt/nginx') do
  it { should_not exist }
end
