class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.integer :team_id
      t.integer :user_id
      t.string :presentation_file_name
      t.string :presentation_content_type
      t.datetime :presentation_updated_at
      t.integer :presentation_file_size
      t.integer :creator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presentations
  end
end
