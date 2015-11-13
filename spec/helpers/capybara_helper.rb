require 'capybara/rspec'
require 'capybara/poltergeist'

RSpec.configure do |_config|
  # Use poltergeist driver for specs requiring JavaScript
  Capybara.javascript_driver = :poltergeist
end
