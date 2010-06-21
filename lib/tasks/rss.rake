require 'rubygems'
require 'rake'
require 'rss'

#Source: http://markmcb.com/2008/07/12/ruby-on-rails-rss-reader/

namespace :cmu do
  desc "Update rss_feeds database table with content from sv.cmu.edu"
  task(:rss => :environment) do
    ##  RAILS_ENV = ENV['RAILS_ENV'] = 'test'

    #if !File.exists?(Dir.pwd+"/config/database.yml")
    #  FileUtils.copy(Dir.pwd+"/config/database.cc.yml", Dir.pwd+"/config/database.yml")
    #end

    MaxRSSItems = 4
    rss = RSS::Parser.parse(open('http://www.cmu.edu/silicon-valley/news-events/rss-news.rss').read, false).items[0..MaxRSSItems-1]
    if rss.size > 0
        @rss_feeds = RssFeed.find(:all)
        @rss_feeds.each do |feed| feed.destroy() end
    end
    rss.each do |item|
      feed = RssFeed.new()
      feed.title = item.title
      feed.link = item.link
  #   http://rubular.com/
  #    Sat, 17 Oct 2009 11:57:50 -0700
  #    [/(\w+), (\d+) (\w+) (\d+) (\d+):(\d+):(\d+)/]
      s = item.pubDate.to_s
      s[/\w+, (\d+) (\w+) (\d+) (\d+):(\d+):(\d+)/]
      month = Date::ABBR_MONTHNAMES.index($2)
      feed.publication_date = DateTime.new(y=$3.to_i,m=month,d=$1.to_i, h=$4.to_i,min=$5.to_i,s=$6.to_i)
      feed.description = item.description
      feed.save()
    end
    puts "RSS table updated"
  end
end