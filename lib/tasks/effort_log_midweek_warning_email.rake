require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Create midweek Scotty Dog warning emails"
  task(:effort_log_midweek_warning_email => :environment) do
    ##  RAILS_ENV = ENV['RAILS_ENV'] = 'test'

    #if !File.exists?(Dir.pwd+"/config/database.yml")
    #  FileUtils.copy(Dir.pwd+"/config/database.cc.yml", Dir.pwd+"/config/database.yml")
    #end

    a = EffortLogsController.new()
    a.create_midweek_warning_email()    #this includes the warning to update the logs even if you already entered a value

  end


  desc "Create grace period warning email"
  task(:effort_log_grace_period_email => :environment) do
    a = EffortLogsController.new()
    a.create_grace_period_expiring_warning_email

  end
end
