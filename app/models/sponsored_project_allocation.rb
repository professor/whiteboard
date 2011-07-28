class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sponsored_project
  validates_presence_of :person_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0
  validates_inclusion_of :is_archived, :in => [true, false]
  validate :unique_person_to_project_allocation?

  def unique_person_to_project_allocation?
    duplicate = SponsoredProjectAllocation.find_by_person_id_and_sponsored_project_id(self.person_id, self.sponsored_project_id)
    unless duplicate.nil? || duplicate.id == self.id
      errors.add(:base, "Can't create duplicate allocation for the same person to project.")
    end
  end

  scope :current, :conditions => {:is_archived => false}
  scope :archived, :conditions => {:is_archived => true}

  default_scope :order => "person_id ASC"


  def self.monthly_copy_to_sponsored_project_effort
    allocations = SponsoredProjectAllocation.find(:all)
    allocations.each do |allocation|
      SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)
    end
  end

  def self.emails_staff_requesting_confirmation_for_allocations
    efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(1.month.ago.month, 1.month.ago.year)
    efforts.each do |effort|
      person = effort.sponsored_project_allocation.person
      unless effort.confirmed || person.emailed_recently(:sponsored_project_effort)
        SponsoredProjectEffortMailer.monthly_staff_email(person, effort.month, effort.year).deliver
        person.sponsored_project_effort_last_emailed = Time.now
        person.save
      end
    end

  end
end
