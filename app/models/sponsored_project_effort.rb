class SponsoredProjectEffort < ActiveRecord::Base
  belongs_to :sponsored_project_allocation
  validates_presence_of :sponsored_project_allocation_id
  validates_inclusion_of :confirmed, :in => [true, false]
  validates_numericality_of :year, :month, :current_allocation, :greater_than_or_equal_to => 0
  validates_numericality_of :actual_allocation, :greater_than_or_equal_to => 0, :allow_blank => true
  validate :unique_month_year_allocation_id?

  def unique_month_year_allocation_id?
    duplicate = SponsoredProjectEffort.find_by_month_and_year_and_sponsored_project_allocation_id(self.month, self.year, self.sponsored_project_allocation_id)
    unless duplicate.nil? || duplicate.id == self.id
      errors.add(:base, "Can't create duplicate effort for the same month, year, and allocation.")
    end
  end

  scope :for_all_users_for_a_given_month,
        lambda { |month, year| {:conditions => ["month = ? and year = ?", month, year]} }

  scope :month_under_inspection_for_a_given_user,
        lambda { |person_id| {:include => :sponsored_project_allocation,
                              :conditions => ["month = ? and year = ? and sponsored_project_allocations.person_id = ?", 1.month.ago.month, 1.month.ago.year, person_id]} }

#  default_scope :include => :sponsored_project_allocation,:order => 'sponsored_project_allocations.person_id ASC'


  def self.new_from_sponsored_project_allocation(allocation)

    SponsoredProjectEffort.create(:month => 1.month.ago.month, :year => 1.month.ago.year,
                                  :sponsored_project_allocation_id => allocation.id,
                                  :current_allocation => allocation.current_allocation,
                                  :actual_allocation => allocation.current_allocation,
                                  :confirmed => false)
  end

  def self.emails_business_manager(an_effort_id)
    effort = SponsoredProjectEffort.find(an_effort_id)
    SponsoredProjectEffortMailer.deliver_changed_allocation_email_to_business_manager(effort.sponsored_project_allocation.person,
                                                                                      effort.month, effort.year)
  end

end
