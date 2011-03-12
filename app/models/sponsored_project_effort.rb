class SponsoredProjectEffort < ActiveRecord::Base
  belongs_to :sponsored_project_allocation
  validates_presence_of :sponsored_project_allocation_id
  validates_inclusion_of :confirmed, :in => [true, false]
  validates_numericality_of :year, :month, :current_allocation, :greater_than_or_equal_to => 0
  validate :unique_month_year_allocation_id?

  def unique_month_year_allocation_id?
    duplicate = SponsoredProjectEffort.find_by_month_and_year_and_sponsored_project_allocation_id(self.month, self.year, self.sponsored_project_allocation_id)
    unless duplicate.nil?
      errors.add_to_base("Can't create duplicate effort for the same month, year, and allocation.")
    end
  end

  named_scope :for_all_users_for_a_given_month,
              lambda { |month, year| {:conditions => ["month = ? and year = ?", month, year] }}

  named_scope :current_months_efforts_for_user,
              lambda { |person_id| {:include => :sponsored_project_allocation,
                                    :conditions => ["month = ? and year = ? and sponsored_project_allocations.person_id = ?", Date.today.month, Date.today.year, person_id] }}

#  default_scope :include => :sponsored_project_allocation,:order => 'sponsored_project_allocations.person_id ASC'


  def self.new_from_sponsored_project_allocation(allocation)
    
    SponsoredProjectEffort.create(:month => Date.today.month, :year => Date.today.year,
                                  :sponsored_project_allocation_id => allocation.id,
                                  :current_allocation => allocation.current_allocation,
                                  :actual_allocation => allocation.current_allocation,
                                  :confirmed => false)
  end
end
