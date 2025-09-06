# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  enable_coverage :branch
  track_files '{app,lib}/**/*.rb'
end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

require 'rspec/rails'
require 'spec_helper'
require 'vcr'

engine_spec_path = Rails.root.join("forecast_ui", "spec")
if Dir.exist?(engine_spec_path)
  Dir[engine_spec_path.join("**/*_spec.rb")].each { |f| require f }
end

SimpleCov.minimum_coverage 100

RSpec.configure do |config|
  config.before(:each) do
    Rails.cache.clear
  end

  config.use_active_record = false

  config.filter_rails_from_backtrace!
end

VCR.configure do |config|
  config.cassette_library_dir = "vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true

  # Filter sensitive ENV vars from cassettes
  config.filter_sensitive_data('<WEATHER_API_KEY>') { ENV['WEATHER_API_KEY'] }
  config.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }
end
