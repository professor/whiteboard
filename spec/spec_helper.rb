require 'rubygems'
require 'spork'
require 'rspec_tag_matchers'
require 'simplecov'
#SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'

# Patch for RubyMine and Spork
ruby_mines = Dir["/Applications/RubyMine*.app"]
unless ruby_mines.empty?
  $LOAD_PATH.unshift "#{ruby_mines.first}/rb/testing/patch/bdd/"
  $LOAD_PATH.unshift "#{ruby_mines.first}/rb/testing/patch/common/"
end

module ControllerMacros
  def login person
    @current_user = User.find(person.id)
    sign_in @current_user
  end
end

module IntegrationSpecHelper
  def login_with_oauth(user, service = :google_apps)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_apps, {
        :user_info => {:email => user.email,
                       :name => user.human_name,
                       :first_name => user.first_name,
                       :last_name => user.last_name}
    })
    visit "/users/auth/#{service}"
  end
end

include ControllerMacros

## Forces all threads to share the same connection. This works on
## Capybara because it starts the web server in a thread.
#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Spork.prefork do

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  #include Capybara::DSL

  require 'shoulda'
  require 'helpers'

  Capybara.default_host = 'http://rails.sv.cmu.edu'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    # == Mock Framework
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    if ENV['CI'] == "true"
      config.filter_run_excluding :skip_on_build_machine => true
    end

    #  config.include ControllerMacros, :type => :controller
    config.include IntegrationSpecHelper, :type => :request

    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view

    #  config.include Helpers
  end

  if Spork.using_spork?
    ActiveSupport::Dependencies.clear
    ActiveRecord::Base.instantiate_observers
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Reload Routes on each run
  CMUEducation::Application.reload_routes!

  # if factories are fixed to be reloadable, uncomment this
  #Factory.factories.clear
  #Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| load(f) unless f.match(/sequence/) }

  # if lib files are reloadable, uncomment this
  #Dir[Rails.root.join("lib/*.rb")].each { |f| load f }
end