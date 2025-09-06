# frozen_string_literal: true
ENV["RAILS_ENV"] ||= "test"

# Boot the dummy app so engine routes/views/controllers are available
require File.expand_path("dummy/config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "rails-controller-testing"

# If you don't use ActiveRecord, make sure RSpec doesn't try to use it.
RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include ForecastUi::Engine.routes.url_helpers, type: :request

  [:controller, :view, :request].each do |type|
    config.include Rails::Controller::Testing::TemplateAssertions, type: type
    config.include Rails::Controller::Testing::Integration,        type: type
    config.include Rails::Controller::Testing::TestProcess,        type: type
  end
end

