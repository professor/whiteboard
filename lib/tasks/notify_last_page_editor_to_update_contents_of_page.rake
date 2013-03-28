require 'rubygems'
require 'rake'

namespace :cmu do
  desc "Send reminders to users"
  task :notify_last_page_editor_to_update_contents_of_page => :environment do

    # Send reminders to update pages that haven't been updated in a while
    ReminderHandler.send_page_update_reminders(Time.now)
  end
end