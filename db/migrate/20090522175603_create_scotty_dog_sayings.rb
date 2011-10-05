class CreateScottyDogSayings < ActiveRecord::Migration
  def self.up
    create_table :scotty_dog_sayings do |t|
      t.text :saying
      t.integer :user_id

      t.timestamps
    end

  end

  def self.down
    drop_table :scotty_dog_sayings
  end
end
