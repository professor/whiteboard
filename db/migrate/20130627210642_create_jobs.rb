class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :title
      t.text   :description
      t.string :skills_must_haves
      t.string :skills_nice_haves
      t.string :duration
      t.string :sponsored_project_id
      t.text :funding_description

      t.boolean :is_accepting, :default => true
      t.boolean :is_closed, :default => false

      t.timestamps
    end

    add_index :jobs, :sponsored_project_id

    create_table :job_supervisors do |t|
      t.integer :job_id
      t.integer :user_id
      t.timestamps
    end

    create_table :job_employees do |t|
      t.integer :job_id
      t.integer :user_id
      t.timestamps
    end

    add_index :job_supervisors, :job_id
    add_index :job_supervisors, :user_id
    add_index :job_employees, :job_id
    add_index :job_employees, :user_id

  end

  def self.down
    drop_table :jobs
    drop_table :job_supervisors
    drop_table :job_employees
  end
end
