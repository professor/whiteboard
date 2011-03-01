class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sponsored_project
  validates_presence_of :person_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0 

  def self.monthly_copy_to_sponsored_project_effort
    allocations = SponsoredProjectAllocation.find(:all)
    allocations.each do |allocation|
      SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)
    end
  end

end
