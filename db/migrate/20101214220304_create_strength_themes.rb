class CreateStrengthThemes < ActiveRecord::Migration
  def self.up
    create_table :strength_themes do |t|
      t.string :theme
      t.string :brief_description
      t.text :long_description
      
      t.timestamps
    end
  end

  def self.down
    drop_table :strength_themes
  end
end
