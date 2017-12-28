# frozen_string_literal: true

describe package('nginx') do
  it { should_not be_installed }
end

describe file('/usr/sbin/nginx') do
  it { should_not exist }
end

%w[
  /opt/nginx
  /var/cache/nginx
  /usr/lib/nginx
].each do |d|
  describe directory(d) do
    it { should_not exist }
  end
end

describe command('ls /var/log/nginx/') do
  its(:stdout) do
    expected = <<-EXPECTED.gsub(/^ +/, '')
      access.log
      error.log
    EXPECTED
    should eq(expected)
  end
end
