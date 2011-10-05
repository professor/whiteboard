class UpdateTelephonesOnUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :telephones, :telephone1
    add_column :users, :telephone1_label, :string
    add_column :users, :telephone2, :string
    add_column :users, :telephone2_label, :string
    add_column :users, :telephone3, :string
    add_column :users, :telephone3_label, :string
    add_column :users, :telephone4, :string
    add_column :users, :telephone4_label, :string

#    User.update_all("telephone1 = 'xxx-xxx-xxxxx'")
  end

  def self.down
    remove_column :users, :telephone4_label
    remove_column :users, :telephone4
    remove_column :users, :telephone3_label
    remove_column :users, :telephone3
    remove_column :users, :telephone2_label
    remove_column :users, :telephone2
    remove_column :users, :telephone1_label
    rename_column :users, :telephones1, :telephones
  end
end
