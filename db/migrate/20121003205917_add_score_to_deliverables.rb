class AddScoreToDeliverables < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :score, :float
    add_column :deliverables, :assignment_id, :integer
    add_column :deliverables, :private_note, :string
    add_index :deliverables, :assignment_id
  end

  def self.down     
    remove_index :deliverables, :assignment_id
    remove_column :deliverables, :private_note
    remove_column :deliverables, :assignment_id
    remove_column :deliverables, :score
  end
end
