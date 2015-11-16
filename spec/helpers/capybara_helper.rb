require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'

RSpec.configure do |_config|
  # Only keeps html and png screenshots from the last test run
  Capybara::Screenshot.prune_strategy = :keep_last_run

  # Use poltergeist driver for specs requiring JavaScript
  Capybara.javascript_driver = :poltergeist

  # Run feature tests in chrome (change to false for faster tests)
  run_in_chrome = false
  if run_in_chrome
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end

    Capybara.javascript_driver = :chrome
  end
end
