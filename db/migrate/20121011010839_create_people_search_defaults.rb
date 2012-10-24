class CreatePeopleSearchDefaults < ActiveRecord::Migration
  def self.up
    create_table :people_search_defaults do |t|
      t.integer :user_id
      t.string :student_staff_group
      t.string :program_group
      t.string :track_group
      t.timestamps
    end
  end

  def self.down
    drop_table :people_search_defaults
  end
end
