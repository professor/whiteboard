class AddOwnerIdToPresentation < ActiveRecord::Migration
  def self.up
    add_column :presentations, :owner_id, :integer
  end

  def self.down
    remove_column :presentations, :owner_id
  end
end
