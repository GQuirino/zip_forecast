require "simplecov"

SimpleCov.start do
  add_filter "/spec/dummy/"
  add_filter "/spec/support/"
  enable_coverage :branch
end

require "webmock/rspec"

# Disable all external HTTP requests by default; allow Rails test server
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.disable_monkey_patching!
end
