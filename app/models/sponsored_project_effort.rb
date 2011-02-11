class SponsoredProjectEffort < ActiveRecord::Base
  belongs_to :sponsored_projects_people
  validates_presence_of :sponsored_projects_people_id
  validates_inclusion_of :confirmed, :in => [true, false]
  validates_numericality_of :year, :month, :current_allocation, :greater_than_or_equal_to => 0

  
end
