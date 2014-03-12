require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env) if defined?(Bundler)
if defined?(Bundler)
  # If you precompile assets before deploying to production,

  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production,

  # Bundler.require(:default, :assets, Rails.env)
end

module CMUEducation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.enforce_available_locales = false
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/services/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    #config.time_zone = 'UTC'
    config.time_zone = "Pacific Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
    config.assets.enabled = true
    config.assets.version = '1.0'
    #config.assets.precompile = [/^[^_]/]
    #config.assets.precompile += %w( mobile.css )
# config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.session_store = {
    :session_key => '_CMUEducation_session',
    :secret      => '1d49995d604604d69d2c9dbb99eadb133c1385c9a2be3aa98d339732b76012b07e3c227f9ea10f2c281c6cfa678d27c02d552ef107ace23df59ba438aa81d47e'
  }     

  end
end

