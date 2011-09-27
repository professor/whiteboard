# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
#require 'spec/autorun' #from rails2, might not be needed
require 'rspec/rails'

#include Capybara::DSL

require 'shoulda'
require 'helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

module ControllerMacros
  def login person
     @current_user = User.find(person.id)
     sign_in @current_user
  end
end

module IntegrationSpecHelper
  def login_with_oauth(service = :google_apps)
    visit "/users/auth/#{service}"
  end
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
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






Capybara.default_host = 'http://rails.sv.cmu.edu'

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:google_apps, {
   :user_info => {:email => 'student.sam@west.cmu.edu',
    :name => 'Student Sam',
    :first_name => 'Student',
    :last_name => 'Sam' }
})


#      sign_in(Factory(:student_sam))
      #sign_in(:student_sam)

#    @student_sam = sign_in(Factory(:student_sam))
#    @student_sam= Factory(:student_sam)
#    sign_in @student_sam


      #@request.env["devise.mapping"] = Devise.mappings[:student_sam]
      #user = Factory.create(:student_sam)
      #sign_in user


include ControllerMacros

##potential fix for authlogic issues
#module LoginHelper
#   include Authlogic::TestCase
#
#   def sign_in_fixture userSymbol
#     activate_authlogic
##     UserSession.create(users(:student_sam))
#     UserSession.create(users(userSymbol))
#   end
#
#   def sign_in person
#     activate_authlogic
#     @current_user = User.find(person.id)
#     UserSession.create(@current_user)
#
#     tmp = current_user
#     a = 1
#   end
#
#
#   def current_user(stubs = {})
#     #current user could get set when being sign_in gets called, otherwise use a generic mock model
#     @current_user ||= mock_model("User", stubs)
#   end
#
#end
#include LoginHelper
#
#
#class ActiveRecord::Base
#  mattr_accessor :shared_connection
#  @@shared_connection = nil
#
#  def self.connection
#    @@shared_connection || retrieve_connection
#  end
#end
#
## Forces all threads to share the same connection. This works on
## Capybara because it starts the web server in a thread.
#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
