class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.string :email
      t.string :twiki_space
      t.string :tigris_space
      t.string :course_id
      t.integer :primary_faculty_id
      t.integer :secondary_faculty_id
      t.string :livemeeting
      t.string :livemeeting
      t.string :livemeeting
      t.timestamps
    end

    create_table :teams_people, :id => false do |t|
      t.integer :team_id
      t.integer :person_id
    end
    
    add_index :teams_people, :team_id
    add_index :teams_people, :person_id 
    
    
  end

  def self.down
    drop_table :teams_people
    drop_table :teams
  end
end
