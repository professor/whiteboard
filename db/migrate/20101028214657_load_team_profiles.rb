require 'active_record/fixtures'

class LoadTeamProfiles < ActiveRecord::Migration
  def self.up
    Fixtures.create_fixtures('db/fixtures', File.basename('users.yml', '.*'))
  end

  def self.down
  end
end
