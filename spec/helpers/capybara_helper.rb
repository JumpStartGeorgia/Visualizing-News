require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'

RSpec.configure do |_config|
  # Only keeps html and png screenshots from the last test run
  Capybara::Screenshot.prune_strategy = :keep_last_run

  # Use poltergeist driver for specs requiring JavaScript
  Capybara.javascript_driver = :poltergeist
end
