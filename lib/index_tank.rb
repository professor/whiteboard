require 'rubygems'
require 'indextank'

module IndexTank

  def self.setup_indexes
    api = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || '<API_URL>')

    indexes = ["cmux"]

    indexes.each do |name|
      index = api.indexes name
      unless index.exists?
        index.add(:public_search => true)
        puts "created index #{name}"
      end
    end

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
