class CreatePageComments < ActiveRecord::Migration
  def self.up
    create_table :page_comments do |t|
      t.integer :user_id
      t.integer :page_id
      t.integer :page_comment_type_id
      t.text :comment
      t.boolean :notify_me
      t.string :display_name
      t.string :semester
      t.integer :year

      t.timestamps
    end

    add_index :page_comments, :user_id
    add_index :page_comments, :page_id
    add_index :page_comments, :semester
    add_index :page_comments, :year

    create_table :page_comment_types do |t|
      t.string :name
      t.string :background_color

      t.timestamps
    end

  end


  def self.down
    drop_table :page_comment_types

    remove_index :page_comments, :year
    remove_index :page_comments, :semester
    remove_index :page_comments, :page_id
    remove_index :page_comments, :user_id

    drop_table :page_comments
  end
end
