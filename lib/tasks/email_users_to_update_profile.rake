require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Email users to update their profile."
  task(:email_users_to_update_profile => :environment) do
    User.recently_signed_on_users.each do |user|
           user.notify_about_missing_fields
    end
  end
end