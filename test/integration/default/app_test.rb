# frozen_string_literal: true

describe package('nginx') do
  it { should be_installed }
end

%w[/opt/nginx /var/log/nginx /var/cache/nginx].each do |d|
  describe directory(d) do
    its(:owner) { should eq('root') }
    its(:group) { should eq('root') }
    its(:mode) { should cmp('0755') }
  end
end

describe command('openssl md5 /etc/passwd') do
  its(:exit_status) { should eq(0) }
  its(:stdout) { should include('MD5(/etc/passwd)=') }
end

describe command('/opt/nginx/embedded/bin/openssl md5 /etc/passwd') do
  its(:exit_status) { should eq(1) }
  its(:stderr) do
    should include('routines:FIPS_DIGESTINIT:disabled for fips:fips_md.c:')
  end
end
