#class TeamMailingListJob < Struct.new(:new_email, :old_email, :id)
#
#  def perform
#  Rails.logger.info("team.update_google_mailing_list(#{new_email}, #{old_email}, #{id}) executed")
#
#  team = Team.find(id)
#
#  new_group = new_email.split('@')[0] unless new_email.blank?
#  old_group = old_email.split('@')[0] unless old_email.blank?
#
#  new_group_exists = false
#  old_group_exists = false
#  google_apps_connection.retrieve_all_groups.each do |list|
#    group_name = list.group_id.split('@')[0]
#    old_group_exists = true if old_group == group_name
#    new_group_exists = true if new_group == group_name
#  end
#  if old_group_exists
#    Rails.logger.info "Deleting #{old_group}"
#    google_apps_connection.delete_group(old_group)
#    new_group_exists = false if old_group == new_group
#  end
#
#  if !new_group_exists
#    Rails.logger.info "Creating #{new_group}"
#    google_apps_connection.create_group(new_group, [team.name, "#{team.name} for course #{team.course.name}", "Domain"])
#  end
#  team.people.each do |member|
#    Rails.logger.info "Teams:adding #{member.email}"
#    google_apps_connection.add_member_to_group(member.email, new_group)
#  end
#
#
#  #verify that this method worked. If it didn't an error will be raised and it will be run again through delayed job
#  all_team_members = google_apps_connection.retrieve_all_members(new_group)
#  google_list = all_team_members.map{|l| l.member_id}.sort
#  team_list = team.people.map{|l| l.email}.sort
#  unless google_list.eql?(team_list)
#    Rails.logger.warn("The people on the google list isn't right")
#    Rails.logger.warn("google list: #{google_list} ")
#    Rails.logger.warn("team list: #{team_list} ")
#  end
#  raise Exception.new("The people on the google list isn't right") unless google_list.eql?(team_list)
#
#  ActiveRecord::Base.connection.execute "UPDATE teams SET updating_email=false WHERE id=#{id}";
#  Rails.logger.info "#{id} -- finished"
#
#  end
#
#end
