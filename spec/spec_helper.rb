require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.


  if ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
# This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

#include Capybara::DSL

  require 'shoulda'
  require 'paperclip/matchers'
  require 'helpers'



# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
#Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

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
                         :last_name => user.last_name }
      })
      visit "/users/auth/#{service}"
    end
  end

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

    config.include Paperclip::Shoulda::Matchers
    #  config.include Helpers
  end

  Capybara.default_host = 'http://rails.sv.cmu.edu'


  include ControllerMacros


## Forces all threads to share the same connection. This works on
## Capybara because it starts the web server in a thread.
#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection


end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

