class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :webiso_account
      t.column :login,                     :string, :limit => 40
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.boolean :is_staff,     :default => false
      t.boolean :is_student,   :default => false
      t.boolean :is_admin,     :default => false   
      t.string :twiki_name
      t.string :first_name
      t.string :last_name
      t.string :human_name #derived column, updated in before_save
      t.string :image_uri
      t.string :graduation_year #student field
      t.string :masters_program #student field
      t.string :masters_track   #student field
      t.boolean :is_part_time   #student field
      
    end
    add_index :users, :login, :unique => true
    add_index :users, :human_name
  end

  def self.down
    drop_table "users"
  end
end
