# frozen_string_literal: true

%w[
  /lib/systemd/system/nginx.servce
  /etc/init/nginx.conf
  /etc/init.d/nginx
].each do |f|
  describe file(f) do
    it { should_not exist }
  end
end

describe service('nginx') do
  it { should_not be_enabled }
  it { should_not be_running }
end
