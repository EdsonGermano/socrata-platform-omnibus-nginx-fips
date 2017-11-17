# frozen_string_literal: true

svc_manager = if command('systemctl --help').exit_status == 0
                'systemd'
              elsif command('initctl --help').exit_status == 0
                'upstart'
              else
                'sysvinit'
              end

case svc_manager
when 'systemd'
  describe file('/lib/systemd/system/nginx.servce') do
    its(:link_path) { should eq('/opt/nginx/init/systemd') }
  end
when 'upstart'
  describe file('/etc/init/nginx.conf') do
    its(:link_path) { should eq('/opt/nginx/init/upstart') }
  end
when 'sysvinit'
  describe file('/etc/init.d/nginx') do
    its(:link_path) do
      dest = if os.debian?
               '/opt/nginx/init/sysvinit.debian'
             elsif os.redhat?
               '/opt/nginx/init/sysvinit.rhel'
             end
      should eq(dest)
    end
  end
end

describe send("#{svc_manager}_service", 'nginx') do
  it { should be_enabled }
  it { should be_running }
end

cmd = case svc_manager
      when 'systemd'
        'systemctl restart nginx'
      when 'upstart'
        'initctl restart nginx'
      when 'sysv'
        '/etc/init.d/nginx restart'
      end

describe command(cmd) do
  its(:exit_status) { should eq(0) }
end

describe send("#{svc_manager}_service", 'nginx') do
  it { should be_running }
end
