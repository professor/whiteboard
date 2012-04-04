class AddRegistrationsTmpForProduction < ActiveRecord::Migration

  def self.up
    drop_table "registrations"

  end

  def self.down
    create_table :registrations, :id => false do |t|
      t.integer :course_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :registrations, :course_id
    add_index :registrations, :user_id
  end
end
