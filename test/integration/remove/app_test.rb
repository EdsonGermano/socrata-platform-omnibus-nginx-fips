# frozen_string_literal: true

describe package('nginx') do
  it { should_not be_installed }
end

describe file('/usr/sbin/nginx') do
  it { should_not exist }
end

%w[
  /opt/nginx
  /var/log/nginx
  /var/cache/nginx
  /usr/lib/nginx
].each do |d|
  describe directory(d) do
    it { should_not exist }
  end
end
