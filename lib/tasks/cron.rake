require 'rubygems'
require 'rake'
require 'fileutils'

#Very good tutorial: http://railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial
#http://railsbros.de/2007/11/19/rake-code-cruise-code-task
#http://abstractplain.net/blog/?p=1024
#http://nullcreations.net/entries/general/enforcing-spec-coverage-with-cruisecontrol-rcov-and-rspec


desc "task for all cron tab entries"
task :cron do

  Rake::Task['cmu:please_do_peer_evaluation_email'].invoke
  Rake::Task['cmu:effort_log_endweek_faculty_email'].invoke
  Rake::Task['cmu:effort_log_midweek_warning_email'].invoke
  Rake::Task['cmu:rss'].invoke
end
