class AddDeliverableGrades < ActiveRecord::Migration
  def self.up
    create_table :deliverable_grades do |t|
      t.integer :user_id
      t.integer :deliverable_id
      t.integer :grade

      t.timestamps
    end

    add_index :deliverable_grades, :user_id
    add_index :deliverable_grades, :deliverable_id
  end

  def self.down
    remove_index :deliverable_grades, :deliverable_id
    remove_index :deliverable_grades, :user_id
    drop_table :deliverable_grades
  end
end