class CreateIndividualContributions < ActiveRecord::Migration

  def self.up
    create_table :individual_contributions do |t|
      t.integer :user_id
      t.integer :year
      t.integer :week_number
      t.timestamps
    end

    add_index :individual_contributions, :user_id
    add_index :individual_contributions, :year
    add_index :individual_contributions, :week_number


    create_table :individual_contribution_for_courses do |t|
      t.integer :individual_contribution_id
      t.integer :course_id
      t.text  :answer1
      t.float :answer2
      t.text  :answer3
      t.text  :answer4
      t.text  :answer5
    end

    add_index :individual_contribution_for_courses, :individual_contribution_id, :name => "individual_contribution_for_courses_icid"
    add_index :individual_contribution_for_courses, :course_id
  end

  def self.down
    drop_table :individual_contribution_for_courses
    drop_table :individual_contributions

  end
end
