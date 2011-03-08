class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sponsored_project
  validates_presence_of :person_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0
  validates_inclusion_of :is_archived, :in => [true, false]

  named_scope :current, :conditions => {:is_archived => false}
  named_scope :archived, :conditions => {:is_archived => true}

  default_scope :order => "person_id ASC"


  def self.monthly_copy_to_sponsored_project_effort
    allocations = SponsoredProjectAllocation.find(:all)
    allocations.each do |allocation|
      SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)
    end
  end

end
