require 'rubygems'
require 'rake'

namespace :cmu do

  desc 'Updates the search indexes needed by this system'
  task :update_search_index => :environment do |t, args|

    pages = Page.all
    pages.each do |page|
      page.update_search_index
    end
  end

end