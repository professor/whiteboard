require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Email users to update their profile."
  task(:email_users_to_update_profile => :environment) do
    User.where(is_profile_valid: false).where(is_active: true).each do |user|
      user.notify_about_missing_field(:biography, "Please update your profile page on whiteboard. You can provide biography information or even just a link to your social profile.")
    end
  end
end