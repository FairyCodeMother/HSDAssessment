# spec/rails_helper.rb
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_bot'
require_relative 'support/chrome'
require 'factory_bot_rails'
require 'database_cleaner/active_record'

# ActiveRecord: Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end





# GINASAURUS ---------------------------------
# docker-compose exec web rspec
RSpec.configure do |config|

  # FactoryBot
  config.include FactoryBot::Syntax::Methods  # Include FactoryBot methods

  config.before(:suite) do
    # Dockerized "remote" URL
    DatabaseCleaner.allow_remote_database_url = true

    # DatabaseCleaner: Clean the database between tests
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # config.before(:each) do
  #   DatabaseCleaner.start
  # end

  config.after(:each) do
    DatabaseCleaner.clean
  rescue => e
    puts "Error cleaning up the database: #{e.message}"
  end

  # Shoulda Matchers configuration
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # Setup for stubbing
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # ActiveRecord/ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# GINASAURUS: docker-compose run web rspec
