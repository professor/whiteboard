require "index_tank"

namespace :cmu do

  desc 'Creates indexes needed by this system'
  task :setup_index_tank_indexes do |t, args|
    IndexTank.setup_indexes
  end

  desc 'Iterate through all page objects and store content in searchify'
  task :update_search_index do |t, args|
    Page.all.each do |page|
      page.update_search_index
    end
  end

end     