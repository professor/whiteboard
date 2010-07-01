# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"
ActionController::Base.asset_host = "http://cmusv-rails-production.s3.amazonaws.com"
#ActionController::Base.asset_host = "http://assets0.rails.sv.cmu.edu"
#ActionController::Base.asset_host = "http://assets%d.rails.sv.cmu.edu"

# Disable delivery errors, bad email addresses will be ignored
## config.action_mailer.raise_delivery_errors = false

#ActionMailer::Base.delivery_method = :sendmail
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.default_charset = "utf-8"

 ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :authentication => :plain,
   :domain => "west.cmu.edu",
   :user_name => "scotty.dog@west.cmu.edu",
#   :domain => ENV['GMAIL_SMTP_USER'],
#   :user_name => ENV['GMAIL_SMTP_USER'],
   :password => ENV['GMAIL_SMTP_PASSWORD'],
   :enable_starttls_auto => true
 }
