class AddTWikiUserFieldsToRails < ActiveRecord::Migration
  def self.up
    add_column :users, :is_active, :boolean
    add_column :users, :legal_first_name, :string
    add_column :users, :organization_name, :string
    add_column :users, :title, :string
    add_column :users, :work_city, :string
    add_column :users, :work_state, :string
    add_column :users, :work_country, :string
    add_column :users, :telephones, :string
    add_column :users, :skype, :string
    add_column :users, :tigris, :string
    add_column :users, :personal_email, :string
    add_column :users, :local_near_remote, :string
    add_column :users, :biography, :string
    add_column :users, :user_text, :string
    add_column :users, :office, :string
    add_column :users, :office_hours, :string

    #User.update_all("local_near_remote = 'Unknown'")
    #User.update_all("telephones = 'Office=xxx-xxx-xxxxx Cell=xxx-xxx-xxxx'")
    #User.update_all("is_active = '1'")
  end

  def self.down
    remove_column :users, :office_hours
    remove_column :users, :office
    remove_column :users, :user_text
    remove_column :users, :biography
    remove_column :users, :local_near_remote
    remove_column :users, :personal_email
    remove_column :users, :tigris
    remove_column :users, :skype
    remove_column :users, :telephones
    remove_column :users, :work_country
    remove_column :users, :work_state
    remove_column :users, :work_city
    remove_column :users, :title
    remove_column :users, :organization_name
    remove_column :users, :legal_first_name
    remove_column :users, :is_active
  end
end
