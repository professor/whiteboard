class AddViewableByToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :viewable_by, :string, :default => "users"
    # possible values : world, users, staff
  end
  def self.down
    remove_column :pages, :viewable_by
  end
end
