require 'rubygems'
require 'rake'
require 'fileutils'
require 'bundler'


#Very good tutorial: http://railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial
#http://railsbros.de/2007/11/19/rake-code-cruise-code-task
#http://abstractplain.net/blog/?p=1024
#http://nullcreations.net/entries/general/enforcing-spec-coverage-with-cruisecontrol-rcov-and-rspec


desc "Task for cruise Control"
task :cruise do
  RAILS_ENV = ENV['RAILS_ENV'] = 'test'

  if !File.exists?(Dir.pwd+"/config/database.yml")
    FileUtils.copy(Dir.pwd+"/config/database.cc.yml", Dir.pwd+"/config/database.yml")
  end

  if !File.exists?(Dir.pwd+"/config/morning_glory.yml")
    FileUtils.copy(Dir.pwd+"/config/morning_glory.default.yml", Dir.pwd+"/config/morning_glory.yml")
  end

#  Now in ~/.profile
#  if !File.exists?(Dir.pwd+"/config/google_apps.yml")
#    FileUtils.copy(Dir.pwd+"/config/google_apps.cc.yml", Dir.pwd+"/config/google_apps.yml")
#  end
#
  if !File.exists?(Dir.pwd+"/config/amazon_s3.yml")
    FileUtils.copy(Dir.pwd+"/config/amazon_s3.cc.yml", Dir.pwd+"/config/amazon_s3.yml")
  end

  
  `bundle install`
  Bundler.setup(:default, :test)


  #Step 1 - Drop and recreate your database
  CruiseControl::invoke_rake_task 'db:test:purge'
  #necessary to reconnect, as purge drops database (and w mysql the conn)
  CruiseControl::reconnect
  CruiseControl::invoke_rake_task 'db:schema:load'
#  CruiseControl::invoke_rake_task 'test'



  #Step 2 - Rcov and TestUnit
  # source: http://deadprogrammersociety.blogspot.com/2007/06/cruisecontrolrb-and-rcov-are-so-good.html
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  ENV['SHOW_ONLY'] = 'models,lib,helpers'
  Rake::Task["test:units:rcov"].invoke
  mv 'coverage/units', "#{out}/unit test coverage" if out

  ENV['SHOW_ONLY'] = 'controllers'
  Rake::Task["test:functionals:rcov"].invoke
  mv 'coverage/functionals', "#{out}/functional test coverage" if out

  Rake::Task["test:integration"].invoke

  #Step 3 - Rcov and Rspec
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  Rake::Task["spec:rcov"].invoke
  mv 'coverage/', "#{out}/spec test coverage" if out


end
