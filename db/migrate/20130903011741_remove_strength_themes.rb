class RemoveStrengthThemes < ActiveRecord::Migration

  def self.up
    drop_table :strength_themes

    remove_column :users, :strength1_id
    remove_column :users, :strength2_id
    remove_column :users, :strength3_id
    remove_column :users, :strength4_id
    remove_column :users, :strength5_id

    remove_column :user_versions, :strength1_id
    remove_column :user_versions, :strength2_id
    remove_column :user_versions, :strength3_id
    remove_column :user_versions, :strength4_id
    remove_column :user_versions, :strength5_id
  end

  def self.down
    create_table :strength_themes do |t|
      t.string :theme
      t.string :brief_description
      t.text :long_description

      t.timestamps
    end

    add_column :users, :strength1_id, :integer
    add_column :users, :strength2_id, :integer
    add_column :users, :strength3_id, :integer
    add_column :users, :strength4_id, :integer
    add_column :users, :strength5_id, :integer

    add_column :user_versions, :strength1_id, :integer
    add_column :user_versions, :strength2_id, :integer
    add_column :user_versions, :strength3_id, :integer
    add_column :user_versions, :strength4_id, :integer
    add_column :user_versions, :strength5_id, :integer

    add_index :users, :strength1_id
    add_index :users, :strength2_id
    add_index :users, :strength3_id
    add_index :users, :strength4_id
    add_index :users, :strength5_id

  end


end
