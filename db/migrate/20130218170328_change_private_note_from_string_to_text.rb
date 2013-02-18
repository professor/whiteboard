class ChangePrivateNoteFromStringToText < ActiveRecord::Migration
  def self.up
    change_column :deliverables, :private_note, :text
  end

  def self.down
    change_column :deliverables, :private_note, :string
  end
end
