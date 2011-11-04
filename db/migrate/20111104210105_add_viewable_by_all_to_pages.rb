class AddViewableByAllToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :is_viewable_by_all, :boolean, :default => true

    #Page.find(:all).each do |p|
    #  p.update_attributes!(:is_viewable_by_all => true)
    # end
  end

  def self.down
    remove_column :pages, :is_viewable_by_all
  end
end
