class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :course_id, :null => false
      t.integer :person_id, :null => false
      t.timestamps
    end

    add_index :registrations, :course_id
    add_index :registrations, :person_id
  end

  def self.down
    drop_table :registrations
  end
end
