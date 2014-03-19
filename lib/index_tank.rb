require 'rubygems'
require 'indextank'

module IndexTank

  def self.setup_indexes
    api = IndexTank::Client.new(ENV['WHITEBOARD_SEARCHIFY_API_URL'] || '<API_URL>')

    index_name_for_all_users = (ENV['WHITEBOARD_SEARCHIFY_INDEX'] || 'cmux')
    index = api.indexes(index_name_for_all_users)
    unless index.exists?
      index.add(:public_search => true)
      puts "created index #{index_name_for_all_users}"
    end

    index_name_for_staff = (ENV['WHITEBOARD_SEARCHIFY_STAFF_INDEX'] || 'cmu_staffx')
    index = api.indexes(index_name_for_staff)
    unless index.exists?
      index.add(:public_search => false)
      puts "created index #{index_name_for_staff}"
    end

    indexes = [index_name_for_all_users, index_name_for_staff ]

    puts "waiting for indexes to startup"
    indexes.each do |name|
      puts "-#{name}"
      index = api.indexes name
      while not index.running?
        sleep 0.5
      end
    end

    puts "all indexes are running"
  end
end
