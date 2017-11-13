# frozen_string_literal: true

describe directory('/etc/nginx') do
  its(:owner) { should eq('root') }
  its(:group) { should eq('root') }
  its(:mode) { should cmp('0755') }
end

describe directory('/etc/nginx/conf.d') do
  its(:owner) { should eq('root') }
  its(:group) { should eq('root') }
  its(:mode) { should cmp('0755') }
end

describe command('ls /etc/nginx/conf.d') do
  its(:stdout) { should eq('') }
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
    its(:link_path) { should eq(File.join('/opt/nginx/embedded/conf', conf)) }
  end

  describe file(File.join('/opt/nginx/conf', conf)) do
    its(:link_path) { should eq(File.join('/opt/nginx/embedded/conf', conf)) }
  end

  describe file(File.join('/opt/nginx/embedded/conf', conf)) do
    its(:owner) { should eq('root') }
    its(:group) { should eq('root') }
    its(:mode) { should cmp('0644') }
  end
end
