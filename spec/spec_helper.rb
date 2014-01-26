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
       :info => {:email => user.email,
          :name => user.human_name,
          :first_name => user.first_name,
          :last_name => user.last_name }
      })
    visit "/users/auth/#{service}"
  end

  def login_with_warden(user, service = :google_apps)
    Warden.test_mode!
    @current_user = User.find(user.id)
    login_as(@current_user, :scope => :user, :run_callbacks => false)
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
  else
    config.filter_run_excluding :skip_on_local_machine => true
  end

  config.include IntegrationSpecHelper, :type => :request

  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view

  config.include Paperclip::Shoulda::Matchers


#  config.include Helpers
end

Capybara.default_host = 'http://whiteboard.sv.cmu.edu'

FactoryGirl.duplicate_attribute_assignment_from_initialize_with = false

include ControllerMacros

## Forces all threads to share the same connection. This works on
## Capybara because it starts the web server in a thread.
#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection


class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

