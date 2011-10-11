#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :openid, nil, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
#end


#ActionController::Dispatcher.middleware do
##  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('./tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
#  use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'west.cmu.edu'
#
#end