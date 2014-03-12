require 'rubygems'
require 'rake'
require 'fileutils'
require 'bundler'

task :continuous_integration => ['db:schema:load', 'spec']


#Very good tutorial: http://railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial
#http://railsbros.de/2007/11/19/rake-code-cruise-code-task
#http://abstractplain.net/blog/?p=1024
#http://nullcreations.net/entries/general/enforcing-spec-coverage-with-cruisecontrol-rcov-and-rspec

task :continuous_integration  => ['db:migrate', 'spec']

task :copy_coverage_report do
  FileUtils.cp_r('coverage', ENV['BUILD_ARTEFACTS'] || 'output', :verbose => true)
end


         
desc "Task for Goldberg"
task :goldberg do
   puts "***** goldberg rake task started"

   puts "***** goldberg rake db:migrate"
  `rake db:migrate`
   puts "***** goldberg rake spec"
  `rake spec`                     
   
   puts "***** goldberg rake task ended"   
end                     
                    


desc "Task for cruise Control"
task :cruise do
  RAILS_ENV = ENV['RAILS_ENV'] = 'test'

  if !File.exists?(Dir.pwd+"/config/database.yml")
    FileUtils.copy(Dir.pwd+"/config/database.cc.yml", Dir.pwd+"/config/database.yml")
  end


  
  `bundle install`
  Bundler.setup(:default, :test)


  #Step 1 - Drop and recreate your database
  puts "***** CruiseControl::invoke_rake_task 'db:test:purge'"
 # CruiseControl::invoke_rake_task 'db:test:purge'
  `rake db:test:purge RAILS_ENV='test'`
  #necessary to reconnect, as purge drops database (and w mysql the conn)

  puts "***** CruiseControl::reconnect"
  #CruiseControl::reconnect

  puts "***** CruiseControl::invoke_rake_task 'db:schema:load'"
  #CruiseControl::invoke_rake_task 'db:schema:load'
  `rake db:schema:load RAILS_ENV='test`


  sleep(1)

  puts "***** Build artifacts"

  #Step 2 - Rcov and TestUnit
  # source: http://deadprogrammersociety.blogspot.com/2007/06/cruisecontrolrb-and-rcov-are-so-good.html
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  puts "***** test:units:rcov"
  ENV['SHOW_ONLY'] = 'models,lib,helpers'
  Rake::Task["test:units:rcov"].invoke
  mv 'coverage/units', "#{out}/unit test coverage" if out

  puts "***** test:functionals:rcov"
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
