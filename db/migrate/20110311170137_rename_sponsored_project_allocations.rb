class RenameSponsoredProjectAllocations < ActiveRecord::Migration
  def self.up
    rename_table :sponsored_project_allocation, :sponsored_project_allocations
  end

  def self.down
    rename_table :sponsored_project_allocations, :sponsored_project_allocation
  end
end
