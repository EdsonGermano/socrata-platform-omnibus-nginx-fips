# frozen_string_literal: true

describe directory('/etc/nginx') do
  its(:owner) { should eq('root') }
  its(:group) { should eq('root') }
  its(:mode) { should cmp('0755') }
end

%w[conf.d sites-available sites-enabled modules].each do |d|
  describe directory(File.join('/etc/nginx', d)) do
    it { should exist }
    its(:owner) { should eq('root') }
    its(:group) { should eq('root') }
    its(:mode) { should cmp('0755') }
  end

  describe command("ls /etc/nginx/#{d}/") do
    its(:stdout) { should eq('') }
  end
end

%w[
  fastcgi.conf
  fastcgi_params
  koi-utf
  koi-win
  mime.types
  nginx.conf
  scgi_params
  uwsgi_params
  win-utf
].each do |conf|
  describe file(File.join('/etc/nginx', conf)) do
    it { should exist }
    its(:link_path) { should eq(File.join('/opt/nginx/embedded/conf', conf)) }
  end

  describe file(File.join('/opt/nginx/conf', conf)) do
    it { should exist }
    its(:link_path) { should eq(File.join('/opt/nginx/embedded/conf', conf)) }
  end

  describe file(File.join('/opt/nginx/embedded/conf', conf)) do
    it { should exist }
    its(:owner) { should eq('root') }
    its(:group) { should eq('root') }
    its(:mode) { should cmp('0644') }
  end
end
