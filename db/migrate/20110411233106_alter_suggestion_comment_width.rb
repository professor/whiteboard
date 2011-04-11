class AlterSuggestionCommentWidth < ActiveRecord::Migration
  def self.up      
    change_column :suggestions, :comment, :text    
  end

  def self.down   
    change_column :suggestions, :comment, :string    
  end
end
