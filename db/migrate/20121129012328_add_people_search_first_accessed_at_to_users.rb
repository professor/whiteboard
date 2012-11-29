class AddPeopleSearchFirstAccessedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :people_search_first_accessed_at, :datetime
    add_column :user_versions, :people_search_first_accessed_at, :datetime
  end

  def self.down
    remove_column :users, :people_search_first_accessed_at
    remove_column :user_versions, :people_search_first_accessed_at
  end
end
