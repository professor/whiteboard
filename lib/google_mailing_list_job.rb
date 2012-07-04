class GoogleMailingListJob < Struct.new(:new_distribution_list, :old_distribution_list, :emails_array, :name, :description, :model_id, :table_name)

  def perform
    Rails.logger.info("#{table_name}.update_google_mailing_list(#{new_distribution_list}, #{old_distribution_list}, #{model_id}) executed")

    new_group = new_distribution_list.split('@')[0] unless new_distribution_list.blank?
    old_group = old_distribution_list.split('@')[0] unless old_distribution_list.blank?

    new_group_exists = false
    old_group_exists = false
    google_apps_connection.retrieve_all_groups.each do |list|
      group_name = list.group_id.split('@')[0]
      old_group_exists = true if old_group == group_name
      new_group_exists = true if new_group == group_name
    end
    if old_group_exists
      Rails.logger.info "Deleting #{old_group}"
      google_apps_connection.delete_group(old_group)
      new_group_exists = false if old_group == new_group
    end

    if !new_group_exists
      Rails.logger.info "Creating #{new_group}"
      google_apps_connection.create_group(new_group, [name, description, "Domain"])
    end
    emails_array.each do |member|
      Rails.logger.info "#{table_name}:adding #{member.email}"
      google_apps_connection.add_member_to_group(member.email, new_group)
    end


    #verify that this method worked. If it didn't an error will be raised and it will be run again through delayed job
    all_team_members = google_apps_connection.retrieve_all_members(new_group)
    google_list = all_team_members.map { |l| l.member_id }.sort
    team_list = emails_array.map { |l| l.email }.sort
    unless google_list.eql?(team_list)
      Rails.logger.warn("The people on the google list isn't right")
      Rails.logger.warn("google list: #{google_list} ")
      Rails.logger.warn("rails list: #{team_list} ")
      raise Exception.new("The people on the google list isn't right \n" + "google list: #{google_list} " + "\n rails list: #{team_list} \n")
    end

    ActiveRecord::Base.connection.execute "UPDATE #{table_name} SET updating_email=false WHERE id=#{model_id}";
    Rails.logger.info "#{model_id} -- finished"

  end

end
