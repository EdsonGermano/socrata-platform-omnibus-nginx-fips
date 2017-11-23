# frozen_string_literal: true

describe package('nginx') do
  it { should_not be_installed }
end

describe file('/usr/sbin/nginx') do
  it { should_not exist }
end

describe command('ls /opt/nginx/') do
  its(:stdout) { should eq("embedded\n") }
end

describe command('ls /opt/nginx/embedded/') do
  its(:stdout) { should eq("logs\n") }
end
