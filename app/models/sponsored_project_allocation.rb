class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sponsored_project
  validates_presence_of :person_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0
  validates_inclusion_of :is_archived, :in => [true, false]
  validate :unique_person_to_project_allocation?

  def unique_person_to_project_allocation?
    duplicate = SponsoredProjectAllocation.find_by_person_id_and_sponsored_project_id(self.person_id, self.sponsored_project_id)
    unless duplicate.nil?
      errors.add_to_base("Can't create duplicate allocation for the same person to project.")
    end
  end

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
