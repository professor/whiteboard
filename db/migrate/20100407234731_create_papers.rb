class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string :title
      t.string :authors
      t.string :authors_more
      t.string :conference
      t.integer :year
      t.string :paper_file_name
      t.string :paper_content_type
      t.integer :paper_file_size
      t.datetime :paper_updated_at
      t.timestamps
    end

    create_table :papers_people, :id => false do |t|
      t.integer :paper_id
      t.integer :person_id
    end
  end

  def self.down
    drop_table :papers
    drop_table :papers_people
  end
end
