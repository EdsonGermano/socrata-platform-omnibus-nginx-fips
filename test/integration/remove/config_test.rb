# frozen_string_literal: true

describe directory('/etc/nginx') do
  it { should_not exist }
end
