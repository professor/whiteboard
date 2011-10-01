class AddIsAlumniToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_alumnus, :boolean    

#UPDATE users SET IS_ALUMNUS = true WHERE graduation_year = "2009"
#UPDATE users SET IS_ACTIVE = false WHERE graduation_year = "2009"
  end



  def self.down
    remove_column :users, :is_alumnus
  end
end
