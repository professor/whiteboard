class AddRegistrations< ActiveRecord::Migration
  def self.up
    create_table :registrations, :id => false do |t|
      t.integer :course_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :registrations, :course_id
    add_index :registrations, :user_id

    drop_table :registered_courses

    add_column :courses, :updating_email, :boolean
  end

  def self.down
    remove_column :courses, :updating_email
    
    create_table "registered_courses" do |t|
      t.integer "course_id"
      t.integer "person_id"
      t.timestamps
    end

    add_index :registered_courses, [:course_id, :person_id], :unique => true


    drop_table "registrations"
  end
end
