require "index_tank"

namespace :index_tank do

  desc 'Creates indexes needed by this system'
  task :setup_indexes do |t, args|
    IndexTank.setup_indexes
  end

end     