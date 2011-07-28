class RemovePapersFromSystem < ActiveRecord::Migration
  def self.up
    remove_index :papers, :date
    remove_index :papers_people, :person_id
    remove_index :papers_people, :paper_id

    drop_table :papers_people
    drop_table :papers
  end

  def self.down
  create_table "papers", :force => true do |t|
    t.string   "title"
    t.string   "authors_full_listing"
    t.string   "conference"
    t.integer  "year"
    t.string   "paper_file_name"
    t.string   "paper_content_type"
    t.integer  "paper_file_size"
    t.datetime "paper_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "citation"
    t.date     "date"
  end

  add_index "papers", ["date"], :name => "index_papers_on_date"

  create_table "papers_people", :id => false, :force => true do |t|
    t.integer "paper_id"
    t.integer "person_id"
  end

  add_index "papers_people", ["paper_id"], :name => "index_papers_people_on_paper_id"
  add_index "papers_people", ["person_id"], :name => "index_papers_people_on_person_id"


  end
end
