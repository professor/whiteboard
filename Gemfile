source 'http://rubygems.org'

gem "rake", "0.8.7"  #As of 7/28/2011, this is needed for "heroku rake db:migrate"
gem 'thin'
gem "daemons", "~> 1.1.4" #this is used by heroku on 7/18/2011

gem 'rails', '3.0.20'
gem 'jquery-rails', '>= 1.0.3'
gem 'aws-sdk'
gem 'mechanize'

gem "webrobots", "~> 0.0.10", :git => 'git://github.com/knu/webrobots.git' #As of 7/1/2011, 0.0.10 was broken -- this is used by mechanize, when it works, remove this line

gem 'omniauth', '0.3.0.rc3'
gem 'devise'


gem "ckeditor", "3.6.3"

#gem 'ruby-openid'
#gem 'ruby-openid-apps-discovery'
#gem 'rack-openid'

gem 'bundler'
gem 'delayed_job' #, '2.1.0.pre'

gem 'indextank'

#gem 'oauth'

#gem 'heroku'
gem 'paperclip'

gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions'
gem 'acts_as_versioned'
gem 'acts_as_list'

gem 'rmagick'

gem 'exception_notification', :require => 'exception_notifier'

gem 'pg'

gem 'cancan'

# gem 'smtp_tls'           # Used for sending mail to gmail
# gem 'actionmailer_gmail' # Used for sending mail to gmail

# gem 'fastercsv'
gem 'vpim'  # user for exporting contacts to vCard and iCalendar support
gem 'seedbank'
gem 'spreadsheet'


group :production do
  gem 'thin'
  gem "daemons", "~> 1.1.4" #this is used by heroku on 7/18/2011

  gem 'newrelic_rpm'

  #gem 'daemons 1.1.4' #this is used by heroku on 7/18/2011
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end

group :development, :test do
#  gem 'mongrel', '>= 1.2.0.pre2', :require => nil
  gem 'launchy'
  gem 'taps'
#  gem 'rake'
  gem 'ruby-debug19'
  gem 'ruby-debug-base19x'
  gem 'ruby-debug-ide' #'0.4.6'

  gem 'shoulda'
#  gem 'hanna'
  gem 'rdoc' #,    '2.4.3' #rdoc_rails required RDoc of 2.4.3 - http://stackoverflow.com/questions/2993435/rake-uninitialized-constant-rdocrdoc
  gem 'rspec-rails'
  gem 'factory_girl_rails', '3.4.0'
  gem 'capybara'
  gem 'jasmine'
  gem 'launchy'

#  gem 'morning_glory'

#  gem 'autotest-rails' if RUBY_PLATFORM =~ /darwin/
#  gem "autotest-fsevent" if RUBY_PLATFORM =~ /darwin/
#  gem 'autotest-growl' if RUBY_PLATFORM =~ /darwin/

#  gem 'test-unit' #, '1.2.3' #Downgrading so that autotest, rspec will work
end



#gem 'gchartrb'
