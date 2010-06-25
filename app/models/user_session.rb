class UserSession < Authlogic::Session::Base
   last_request_at_threshold = 2.minutes

    # specify configuration here, such as:
    # logout_on_timeout true
    # ...many more options in the documentation
end