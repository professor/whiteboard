class AlterCourseConfigurationForPeerEvaluations < ActiveRecord::Migration
  def self.up

    rename_column :courses, :configure_peer_evaluation_date1, :peer_evaluation_first_email
    rename_column :courses, :configure_peer_evaluation_date2, :peer_evaluation_second_email
  end

  def self.down
    rename_column :courses, :peer_evaluation_second_email, :configure_peer_evaluation_date2
    rename_column :courses, :peer_evaluation_first_email, :configure_peer_evaluation_date1
  end
end
