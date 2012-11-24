require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Do update_user_profile_email"
  task(:update_user_profile_email => :environment) do
    users = User.all
    users.each do |user|
      notification_fields = user.notify_about_missing_field
      unless notification_fields.empty?
        message = "The following fields from your profile need your attention: \n"
        notification_fields.each do |val|
          message += "#{val}\n"
        end

        options = {:to => user.email,
                   :subject => "Your user profile needs updating",
                   :message => message,
                   :url_label => "Modify your profile",
                   :url => Rails.application.routes.url_helpers.edit_user_url(user, :host => "rails.sv.cmu.edu")
        }
        GenericMailer.email(options).deliver
      end
    end
  end
end