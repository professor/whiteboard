class AddConfigureFieldsToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :configure_class_mailinglist, :boolean, :default => false
    add_column :courses, :configure_peer_evaluation_date1, :date
    add_column :courses, :configure_peer_evaluation_date2, :date
    add_column :courses, :configure_teams_name_themselves, :boolean, :default => true
    add_column :courses, :curriculum_url, :string
    add_column :courses, :configure_course_twiki, :boolean, :default => false
    add_column :courses, :is_configured, :boolean, :default => false

    create_table :courses_people do |t|
      t.integer :course_id
      t.integer :person_id
      t.timestamps
    end
  end

  def self.down
    remove_column :courses, :is_configured
    remove_column :courses, :configure_course_twiki
    remove_column :courses, :curriculum_url
    remove_column :courses, :configure_teams_name_themselves
    remove_column :courses, :configure_peer_evaluation_date2
    remove_column :courses, :configure_peer_evaluation_date1
    remove_column :courses, :configure_class_mailinglist

    drop_table :courses_people
  end


end
