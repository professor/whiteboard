source 'http://rubygems.org'

gem 'rails', '3.0.9'
gem 'jquery-rails', '>= 1.0.3'
gem 'aws-s3'
gem 'mechanize'

gem 'webrobots', '0.0.9' #As of 7/1/2011, 0.0.10 was broken -- this is used by mechanize, when it works, remove this line



gem 'ruby-openid'
gem 'ruby-openid-apps-discovery'
gem 'rack-openid'

gem 'bundler'
gem 'delayed_job' #, '2.1.0.pre'


gem 'oauth'

gem 'heroku'
gem 'taps'
gem 'paperclip' 

#gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions'

gem 'rmagick'

gem 'authlogic'

gem 'exception_notification', :require => 'exception_notifier'

# gem 'smtp_tls'           # Used for sending mail to gmail
# gem 'actionmailer_gmail' # Used for sending mail to gmail

group :production do         
  gem 'rack-google_analytics', :require => "rack/google_analytics"
  gem 'rcov' #This should not be necessary, but it's used by the Rakefile and it needs to be removed
  gem 'factory_girl' #This is necessary when we want to load factory seeds into a production database

  gem 'vestal_versions' #, '1.0.2' #, :git => 'git://github.com/laserlemon/vestal_versions'
end

group :development, :test do
  gem 'rake'
  gem 'pg'
  gem 'mongrel', '>= 1.2.0.pre2', :require => nil
  gem 'ruby-debug19'
  gem 'ruby-debug-base19x'
  gem 'ruby-debug-ide' #'0.4.6'
  gem 'shoulda'
#  gem 'hanna'
  gem 'rcov'
  gem 'rdoc' #,    '2.4.3' #rdoc_rails required RDoc of 2.4.3 - http://stackoverflow.com/questions/2993435/rake-uninitialized-constant-rdocrdoc
  gem 'rspec-rails'
  gem 'mocha'
  gem 'factory_girl'
  gem 'capybara'

#  gem 'autotest-rails' if RUBY_PLATFORM =~ /darwin/
#  gem "autotest-fsevent" if RUBY_PLATFORM =~ /darwin/
#  gem 'autotest-growl' if RUBY_PLATFORM =~ /darwin/

  gem 'test-unit' #, '1.2.3' #Downgrading so that autotest, rspec will work

  gem 'vestal_versions' #, '1.0.2' #, :git => 'git://github.com/laserlemon/vestal_versions'
end



#gem 'gchartrb'
