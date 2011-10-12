class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :course_number_id
      t.string :label
      t.integer :position
      t.integer :indentation_level
      t.boolean :is_task
      t.text :tab_one_contents
      t.text :tab_two_contents
      t.text :tab_three_contents
      t.integer :task_duration
      t.string :tab_one_email_from
      t.string :tab_one_email_subject

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
