class CreateIndividualContributions < ActiveRecord::Migration

  def self.up
    create_table :individual_contributions do |t|
      t.integer :user_id
      t.integer :year
      t.integer :week_number
      t.timestamps
    end

    add_index :individual_contributions, :user_id
    add_index :individual_contributions, :year
    add_index :individual_contributions, :week_number
  end

  def self.down
    drop_table :individual_contributions

  end
end
