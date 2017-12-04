# frozen_string_literal: true

describe package('nginx') do
  it { should be_installed }
end

describe command('/usr/sbin/nginx -V') do
  %w[
    --with-threads
    --with-debug
    --with-compat
    --with-file-aio
    --with-http_addition_module
    --with-http_auth_request_module
    --with-http_dav_module
    --with-http_flv_module
    --with-http_gunzip_module
    --with-http_gzip_static_module
    --with-http_mp4_module
    --with-http_random_index_module
    --with-http_realip_module
    --with-http_secure_link_module
    --with-http_slice_module
    --with-http_ssl_module
    --with-http_stub_status_module
    --with-http_sub_module
    --with-http_v2_module
    --with-mail
    --with-mail_ssl_module
    --with-stream
    --with-stream_realip_module
    --with-stream_ssl_module
    --with-stream_ssl_preread_module
  ].each do |flag|
    its(:stdout) { should include(flag) }
  end
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
