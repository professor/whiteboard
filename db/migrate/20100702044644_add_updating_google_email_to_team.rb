class AddUpdatingGoogleEmailToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :updating_email, :boolean
  end

  def self.down
    remove_column :teams, :updating_email
  end
end
