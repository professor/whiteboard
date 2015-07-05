source 'http://rubygems.org'
ruby '2.1.1'
#test

gem 'rake'
gem 'unicorn'

gem 'rails', '3.2.22'
gem 'strong_parameters'
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'asset_sync'
end
gem 'jquery-rails', '>= 1.0.3'
gem 'aws-sdk', '1.34.0'
gem 'mechanize'

gem 'webrobots', '~> 0.1.1'

gem 'omniauth-google-oauth2'

gem 'devise', '2.2.8'
gem 'bcrypt-ruby', '3.0.1' #https://stackoverflow.com/questions/12879892/rails-on-heroku-activerecordstatementinvalid-pgerror-ssl-error-cert-already

gem 'ckeditor_rails', '4.3.1'


gem 'bundler', '1.9.6'
gem 'delayed_job', '2.1.4'

gem 'indextank'

gem 'paperclip', '2.5.0'

gem 'vestal_versions', :git => 'git://github.com/laserlemon/vestal_versions'
# gem 'acts_as_versioned', :git => 'https://github.com/jwhitehorn/acts_as_versioned.git'
# gem 'acts_as_versioned_jw', '~> 3.2.2'
gem 'db_acts_as_versioned', '~> 3.5.0'

gem 'acts_as_list'

gem 'rmagick'

gem 'exception_notification'

gem 'pg'

gem 'net-ldap'

gem 'recaptcha', :require => 'recaptcha/rails'

gem 'cancan'

gem 'google-api-client', '0.8.1'

gem 'vpim'  # user for exporting contacts to vCard and iCalendar support
gem 'seedbank'
gem 'spreadsheet'
gem 'cocaine' , '0.3.2'
group :production do
  gem 'thin'
  gem 'daemons', '~> 1.1.4' #this is used by heroku on 7/18/2011

  gem 'newrelic_rpm'

  gem 'rack-google_analytics', :require => 'rack/google_analytics'
end

group :development, :test do
  gem 'launchy'
  gem 'taps'
  gem 'travis'
  gem 'foreman'

  # see this link for details on which gem to install for debugger
  # http://stackoverflow.com/questions/10323119/cannot-load-such-file-script-rails-getting-this-error-while-remote-debuggin/10325110#10325110
  #gem 'ruby-debug-base19x'
  #gem 'ruby-debug-ide'
  #gem 'linecache19', '>= 0.5.13', :git => 'https://github.com/robmathews/linecache19-0.5.13.git'

  # gem 'ruby-debug-base19x', '>= 0.11.30.pre10'
  # gem 'ruby-debug-ide', '>= 0.4.17.beta14'
  # gem 'ruby-debug19', :require => 'ruby-debug'


  gem 'shoulda'
  gem 'rspec', '2.14.1'
  gem 'rdoc' #,    '2.4.3' #rdoc_rails required RDoc of 2.4.3 - http://stackoverflow.com/questions/2993435/rake-uninitialized-constant-rdocrdoc
  gem 'rspec-rails', '2.14.1'
  gem 'factory_girl_rails', '3.4.0'
  gem 'capybara', '1.1.1'
  gem 'jasmine', '2.0.0'
  gem 'ladle', '~> 0.2.0'

  gem 'selenium-webdriver'
  gem 'rails_best_practices'
end
