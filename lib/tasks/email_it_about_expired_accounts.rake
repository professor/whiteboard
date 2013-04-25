require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Email to IT about expired user accounts"
  task(:email_it_about_expired_accounts => :environment) do
    User.notify_it_about_expired_accounts()
  end
end
