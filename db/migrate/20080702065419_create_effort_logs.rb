class CreateEffortLogs < ActiveRecord::Migration
  def self.up
    create_table :effort_logs do |t|
      t.integer :person_id
      t.integer :week_number
      t.integer :year
      t.timestamps
    end
    
    add_index :effort_logs, :person_id
    add_index :effort_logs, :week_number    
  end

  def self.down
    drop_table :effort_logs
  end
end
