require "index_tank"

namespace :cmu do

  desc 'Creates indexes needed by this system'
  task :setup_index_tank_indexes do |t, args|
    IndexTank.setup_indexes
  end

end     