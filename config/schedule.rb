# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, :at => "12:30am" do
  rake "facebook_update:visuals"
  rake "facebook_update:ideas"
#  rake "facebook_update:visuals", :output => {:standard => "/var/log/cron.feradi.fb_visuals.log", :error => "/var/log/cron.feradi.fb_visuals.errors.log"}
#  rake "facebook_update:ideas", :output => {:standard => "/var/log/cron.fb_ideas.feradi.log", :error => "/var/log/cron.feradi.fb_ideas.errors.log"}
end


