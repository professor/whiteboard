class DelayedSystemJob < ActiveRecord::Base
  self.table_name = 'delayed_jobs'
end
