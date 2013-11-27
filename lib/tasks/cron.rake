require 'rubygems'
require 'rake'
require 'fileutils'

#Very good tutorial: http://railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial
#http://railsbros.de/2007/11/19/rake-code-cruise-code-task
#http://abstractplain.net/blog/?p=1024
#http://nullcreations.net/entries/general/enforcing-spec-coverage-with-cruisecontrol-rcov-and-rspec


desc "task for all cron tab entries"
task :cron do

 puts "---Running task :cron"

 if Date.today.wday == 5 ||  Date.today.wday == 0 # run on Fridays and Sundays
   puts "----Updating cmu:effort_log_midweek_warning_email"
   Rake::Task['cmu:effort_log_midweek_warning_email'].invoke
   puts "----done."
 end

 if Date.today.wday == 1 # run on Mondays
   puts "----Updating cmu:effort_log_endweek_faculty_email"
   Rake::Task['cmu:effort_log_endweek_faculty_email'].invoke
   puts "----done."
 end

 if Date.today.day == 1 # run on the first on the month
   puts "----Copy cmu:sponsored_projects efforts and email"
   Rake::Task['cmu:sponsored_projects:monthly_copy_to_sponsored_project_effort'].invoke
   Rake::Task['cmu:sponsored_projects:emails_staff_requesting_confirmation_for_allocations'].invoke
   puts "----done."
 end

 if Date.today.day == 1
   puts "----Copy cmu:email_it_about_expired_accounts"
   Rake::Task['cmu:email_it_about_expired_accounts'].invoke
   puts "----done."
 end

 if Date.today.day == 1 && Date.today.month.odd? # run on first day of an odd month
   # orientation is in Aug, so we want it to run in Sep
   puts "----Send cmu:email_users_to_update profile email"
   Rake::Task['cmu:email_users_to_update_profile'].invoke
   puts "----done."
 end

 if Date.today.day == 10 || Date.today.day == 15
   puts "----Send cmu:sponsored_projects email"
   Rake::Task['cmu:sponsored_projects:emails_staff_requesting_confirmation_for_allocations'].invoke
   puts "----done."
 end

  #Run every day
  Rake::Task['cmu:please_do_peer_evaluation_email'].invoke
  Rake::Task['cmu:rss'].invoke
  Rake::Task['cmu:notify_last_page_editor_to_update_contents_of_page'].invoke
end
