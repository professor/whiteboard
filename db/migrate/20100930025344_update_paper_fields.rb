class UpdatePaperFields < ActiveRecord::Migration
  def self.up
    add_column :papers, :citation, :text
    add_column :papers, :date, :date
    add_index :papers, :date
  end

  def self.down
    remove_index :papers, :date
    remove_column :papers, :citation
    remove_column :papers, :date
  end
end
