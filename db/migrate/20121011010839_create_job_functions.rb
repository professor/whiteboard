class CreateJobFunctions < ActiveRecord::Migration
  def self.up
    create_table :job_functions do |t|
      t.integer :user_id
      t.string :title
      t.string :pt_ft_group
      t.string :student_staff_group
      t.string :program_group
      t.string :track_group

      t.timestamps
    end
  end

  def self.down
    drop_table :job_functions
  end
end
