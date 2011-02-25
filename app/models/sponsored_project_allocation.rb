class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sponsored_project
  validates_presence_of :person_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0 
end
