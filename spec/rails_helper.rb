# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'spec_helper'
require 'vcr'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
end

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
