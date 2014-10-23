require File.expand_path('../support/unit/rails_application', __FILE__)

$test_app = UnitTests::RailsApplication.new
$test_app.create
$test_app.load

ENV['BUNDLE_GEMFILE'] ||= app.gemfile_path
ENV['RAILS_ENV'] = 'test'

require 'shoulda/matchers'
require 'rspec/rails'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

Dir[ File.join(File.expand_path('../support/unit/**/*.rb', __FILE__)) ].sort.each do |file|
  require file
end

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec

  if config.respond_to?(:infer_spec_type_from_file_location!)
    config.infer_spec_type_from_file_location!
  end

  config.include Shoulda::Matchers::ActionController, type: :controller

  UnitTests::ActiveModelHelpers.configure_example_group(config)
  UnitTests::ActiveModelVersions.configure_example_group(config)
  UnitTests::ActiveResourceBuilder.configure_example_group(config)
  UnitTests::ClassBuilder.configure_example_group(config)
  UnitTests::ControllerBuilder.configure_example_group(config)
  UnitTests::I18nFaker.configure_example_group(config)
  UnitTests::MailerBuilder.configure_example_group(config)
  UnitTests::ModelBuilder.configure_example_group(config)
  UnitTests::RailsVersions.configure_example_group(config)

  config.include UnitTests::Matchers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

$VERBOSE = true
