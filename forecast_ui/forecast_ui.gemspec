require_relative "lib/forecast_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "forecast_ui"
  spec.version     = ForecastUi::VERSION
  spec.authors     = [ "Guilherme Quirino de Melo" ]
  spec.email       = [ "guilhermequirino74@gmail.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of ForecastUi."
  spec.description = "TODO: Description of ForecastUi."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2.1"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rails-controller-testing"
end
