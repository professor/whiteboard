class CreatePeople < ActiveRecord::Migration
  
  #People is a shadow model that allows us to create User records without going through the password verification. Since they have andrew accounts, they don't need passwords
  
  def self.up
    create_table :people do |t|
      t.string :twiki_name
      t.string :first_name
      t.string :last_name
      t.string :human_name #derived column, updated in before_save
      t.boolean :is_staff,     :default => false
      t.boolean :is_student,   :default => false
      t.boolean :is_admin,     :default => false
      t.string :webiso_account
      t.string :image_uri
      t.string :graduation_year #student field
      t.string :masters_program #student field
      t.string :masters_track   #student field
      t.boolean :is_part_time   #student field
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.timestamps
    end
    add_index :people, :human_name

  end

  def self.down
    drop_table :people
  end
end
