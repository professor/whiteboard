source 'http://rubygems.org'

gem 'rails',	'2.3.4'
gem 'aws-s3'
gem 'mechanize', '1.0.0'
gem 'ruby-openid'
gem 'ruby-openid-apps-discovery'
gem 'rack-openid'

gem 'bundler'
gem 'delayed_job', '2.1.0.pre'


gem 'oauth'

gem 'heroku'
gem 'taps'

group :plugins do
  gem 'authlogic'
  gem 'calendar_date_select' 
end



# gem 'smtp_tls'           # Used for sending mail to gmail
# gem 'actionmailer_gmail' # Used for sending mail to gmail

group :production do
#  gem 'activerecord-postgresql-adapter'
end

group :development, :test do
  gem 'rake'
  gem 'sqlite3-ruby'
  gem 'mongrel'
  gem 'ruby-debug-base' #'0.10.3'
  gem 'ruby-debug-ide' #'0.4.6'
  gem 'shoulda'
#  gem 'hanna'
  gem 'rcov'
  gem 'rdoc',    '2.4.3' #rdoc_rails required RDoc of 2.4.3 - http://stackoverflow.com/questions/2993435/rake-uninitialized-constant-rdocrdoc
  gem 'rspec-rails'
  gem 'mocha'
  gem 'rspec'
  gem 'factory_girl'

  gem 'autotest-rails' if RUBY_PLATFORM =~ /darwin/
  gem "autotest-fsevent" if RUBY_PLATFORM =~ /darwin/
  gem 'autotest-growl' if RUBY_PLATFORM =~ /darwin/  
  gem 'test-unit', '=1.2.3' #Downgrading so that autotest, rspec will work
end



#gem 'gchartrb'
