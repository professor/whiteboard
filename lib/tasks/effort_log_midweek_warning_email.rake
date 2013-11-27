require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Create midweek Scotty Dog warning emails"
  task(:effort_log_midweek_warning_email => :environment) do
    a = EffortLogsController.new()
    a.create_midweek_warning_email()

  end
end
