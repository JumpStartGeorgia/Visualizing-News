# Load the rails application
require File.expand_path('../application', __FILE__)

#support for locale fallbacks
 require "i18n/backend/fallbacks"
 I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
 
# Initialize the rails application
BootstrapStarter::Application.initialize!

