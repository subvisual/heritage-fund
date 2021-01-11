require 'capybara/rspec'
require 'capybara/apparition'

RSpec.configure do |config|
  # Exclude running accessibility tests by default
  config.filter_run_excluding accessibility: true

  # Set the Capybara driver when running accessibility tests using
  # bundle exec rspec --tag accessibility
  Capybara.current_driver = :apparition if config.filter_manager.inclusions.rules.include?(:accessibility)
end
