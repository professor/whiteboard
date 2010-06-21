require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Create endweek Scotty Dog faculty emails"
  task(:effort_log_endweek_faculty_email => :environment) do
    ##  RAILS_ENV = ENV['RAILS_ENV'] = 'test'

    #if !File.exists?(Dir.pwd+"/config/database.yml")
    #  FileUtils.copy(Dir.pwd+"/config/database.cc.yml", Dir.pwd+"/config/database.yml")
    #end

    a = EffortLogsController.new()
    a.create_endweek_faculty_email()

  end
end