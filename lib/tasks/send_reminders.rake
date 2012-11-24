require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Send reminders to users"
  task :send_reminders => :environment do

    # Send reminders to update pages that haven't been updated in a while
    ReminderHandler.send_page_update_reminders(1.year.ago)
  end
end