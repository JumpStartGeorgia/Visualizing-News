# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }

# You can also remove all the silencers if you're trying to debug a problem that might stem from framework code.
# Rails.backtrace_cleaner.remove_silencers!

IMGKit.configure do |config|
	y = YAML.load_file(File.open(Rails.root.join("config", "database.yml")))

	config.wkhtmltoimage = Rails.root.join('vendor', 'bin', 'wkhtmltoimage-amd64').to_s
	config.wkhtmltoimage = Rails.root.join('vendor', 'bin', 'wkhtmltoimage-i386').to_s if y["development"]["imgkit32"]
  config.default_options = {
    :quality => 100
  }
  config.default_format = :png
end
