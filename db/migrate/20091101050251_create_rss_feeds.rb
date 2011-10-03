class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    create_table :rss_feeds do |t|
      t.string :title
      t.string :link
      t.datetime :publication_date
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :rss_feeds
  end
end
