RSpec.configure do |config|
  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end
end
