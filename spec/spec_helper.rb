# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
#require 'spec/autorun' #from rails2, might not be needed
require 'rspec/rails'

#include Capybara::DSL

require 'authlogic/test_case'
require 'shoulda'
require 'helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

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


#  config.include Helpers
end


#potential fix for authlogic issues
module LoginHelper
   include Authlogic::TestCase

   def login_user_fixture userSymbol
     activate_authlogic
#     UserSession.create(users(:student_sam))
     UserSession.create(users(userSymbol))
   end

   def login_user person
     activate_authlogic
     @current_user = User.find(person.id)
     UserSession.create(@current_user)

     tmp = current_user
     a = 1
   end


   def current_user(stubs = {})
     #current user could get set when being login_user gets called, otherwise use a generic mock model
     @current_user ||= mock_model("User", stubs)
   end

end
include LoginHelper


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

#class ActionController::TestCase
#  puts "********** Authlogic setup **************"
#  setup :activate_authlogic
#
##  def login_as(user)
##    if user.nil?
##      return UserSession.stubs(:find).returns(nil)
##    else
##      return UserSession.stubs(:find).returns(UserSession.create(users(user)))
##    end
##  end
#end

#Helpers for authlogic and rspec

#def current_user(stubs = {})
#  @current_user ||= mock_model("User", stubs)
#end

# =============== OLD STUFF ===============
# this stuff is from rails2 (old spec helper), might not be needed

#Helpers for authlogic and rspec
#

#
#def user_session(stubs = {}, user_stubs = {})
#  @current_user ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
#end
#
#def login(session_stubs = {}, user_stubs = {})
#  UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
#end
#
#def logout
#  @user_session = nil
#end
