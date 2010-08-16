
#AMAZON_S3_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml")[RAILS_ENV]
#SYSTEMS_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/systems.yml")

GOOGLE_USERNAME = ENV['GOOGLE_USERNAME'] || "team.deming@sandbox.sv.cmu.edu"
GOOGLE_PASSWORD = ENV['GOOGLE_PASSWORD'] || "MfSE@sv"
GOOGLE_DOMAIN = ENV['GOOGLE_DOMAIN'] || "sandbox.sv.cmu.edu"

require 'gappsprovisioning/provisioningapi'
include GAppsProvisioning
def google_apps_connection
  @google_apps_connection ||= ProvisioningApi.new(GOOGLE_USERNAME, GOOGLE_PASSWORD)
rescue
  Rails.logger.debug "had to rescue (ie reconnect) google apps"
  Rails.logger.info "had to rescue (ie reconnect) google apps"
  @google_apps_connection = ProvisioningApi.new(GOOGLE_USERNAME, GOOGLE_PASSWORD)
end

#This code works for a person's email address or a team's distribution list
def switch_sv_to_west(email_address)
     return nil if email_address.nil?
     (name, domain) = email_address.split('@')
     if(domain == "sv.cmu.edu")
        email_address = name + "@west.cmu.edu"
     end
     return email_address
end

def switch_west_to_sv(email_address)
      return nil if email_address.nil?
     (name, domain) = email_address.split('@')
     if(domain == "west.cmu.edu")
        email_address = name + "@sv.cmu.edu"
     end
     return email_address
end

def pretty_print_google_error(e)
    logger.debug "errorcode = " +e.code + "input : " + e.input + "reason : "+e.reason
    return "Mailing list already exists." if e.code.to_i == 1300
    return "Mailing list does not exist." if e.code.to_i == 1301
    return e.reason + " (" + e.code + ") for " + e.input + "."
end


# The following was added to connect to the provisioning Google APPS API by Greg Hilton
# I have not seen this code functioning.


def wait_for_google_sync
end
#
#def wait_for_google_sync
#  until $google_thread_items.empty?
#    sleep 1
#  end
#  sleep 0.2 # this delay is just to be save
#  Rails.logger.debug "Synced with Google Apps at #{Time.now}"
#end
#
#$google_thread_items = []
#
#
#def async_google_add_member(user_email,team_name)
#  $google_thread_items << Proc.new {
#    begin
#      google_apps = google_apps_connection
#      #Rails.looger.debug "\n#{Time.now}: add #{user_email} form #{team_name}"
#      unless google_apps.is_member(user_email, team_name)
#        google_apps.add_member_to_group(user_email, team_name)
#      end
#    rescue GDataError => e
#      Rails.logger.error "\n\nAttempting to populate group.  errorcode = #{e.code}, input : #{e.input}, reason : #{e.reason}\n\n"
#    end
#  }
#end
#def async_google_remove_member(user_email,team_name)
#  $google_thread_items << Proc.new {
#    begin
#      google_apps = google_apps_connection
#      #Rails.looger.debug "\n#{Time.now}: remove #{user_email} form #{team_name}"
#      if google_apps.is_member(user_email, self.email_builder)
#        google_apps.remove_member_from_group(user_email,team_name)
#      end
#    rescue GDataError => e
#      Rails.logger.error "Attempting to remove member form group.  errorcode = " +e.code, "input : "+e.input, "reason : "+e.reason
#    end
#  }
#end
#
#def async_google_update_mailing_list(old_email, new_email, team_name, course_name)
#  $google_thread_items << Proc.new {
#      google_apps = google_apps_connection
#    #Rails.looger.debug "\n#{Time.now}: updating #{old_email} to #{new_email}"
#    new_group_exists = 1
#    old_group_exists = 0
#    google_apps.retrieve_all_groups.each do |list|
#      #Rails.looger.debug list.group_id
#      group_name = list.group_id.split('@')[0]
#      #Rails.looger.debug "DEBUG: #{group_name} vs #{self.old_email} vs #{self.email_builder}"
#      if "#{old_email}" == "#{group_name}"
#        #Rails.looger.debug "DEBUG:Will remove old"
#        old_group_exists = 1
#      end
#      if "#{self.email_builder}" == "#{group_name}"
#        #Rails.looger.debug "DEBUG:Will create group"
#        new_group_exists = 0
#      end
#    end
#    if old_group_exists == 1
#      #Rails.looger.debug "\n\n\n\nDEBUG:  Deleting #{old_email}\n\n\n\n"
#      google_apps.delete_group(old_email)
#    end
#    if new_group_exists == 0
#      Rails.logger.info "\n\n\n\nDEBUG:  Creating #{new_email}\n\n\n\n"
#      Rails.logger.info "#{new_email} -- #{team_name} course #{course_name}"
#      google_apps.create_group(new_email, [team_name, "#{team_name} for course #{course_name}", "Domain"])
#    end
#  }
#end
#
#def threading
#  while true
#    unless $google_thread_items.empty?
#      logger.debug "Google thread - running process"
#      $google_thread_items[0].call
#      sleep 5
#      $google_thread_items.shift
#      logger.debug "Google thread - process complete"
#    end
#    sleep 0.5
#    logger.debug "DEBUG THREADING #{Time.now}"
#  end
#end
#@google_thread = Thread.new { threading }