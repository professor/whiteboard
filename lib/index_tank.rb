require 'rubygems'
require 'indextank'

module IndexTank

  def self.setup_indexes
    api = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || '<API_URL>')

    index = api.indexes "cmux"
    unless index.exists?
      index.add(:public_search => true)
      puts "created index #{name}"
    end

    index = api.indexes "cmux_staffx"
    unless index.exists?
      index.add(:public_search => false)
      puts "created index #{name}"
    end

    indexes = ["cmux", "cmux_staffx"]

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
