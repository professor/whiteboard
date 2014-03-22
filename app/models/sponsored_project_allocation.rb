class SponsoredProjectAllocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :sponsored_project
  validates_presence_of :user_id, :sponsored_project_id
  validates_numericality_of :current_allocation, :greater_than_or_equal_to => 0
  validates_inclusion_of :is_archived, :in => [true, false]
  validate :unique_user_to_project_allocation?

  def unique_user_to_project_allocation?
    duplicate = SponsoredProjectAllocation.find_by_user_id_and_sponsored_project_id(self.user_id, self.sponsored_project_id)
    unless duplicate.nil? || duplicate.id == self.id
      errors.add(:base, "Can't create duplicate allocation for the same person to project.")
    end
  end

  scope :current, :conditions => {:is_archived => false}
  scope :archived, :conditions => {:is_archived => true}

  default_scope :order => "user_id ASC"

  def self.monthly_copy_to_sponsored_project_effort
    allocations = SponsoredProjectAllocation.current
    allocations.each do |allocation|
      SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)
    end
  end

  def self.emails_staff_requesting_confirmation_for_allocations
    efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(1.month.ago.month, 1.month.ago.year)
    efforts.each do |effort|
      user = effort.sponsored_project_allocation.user
      unless effort.confirmed || user.emailed_recently(:sponsored_project_effort)
        SponsoredProjectEffortMailer.monthly_staff_email(user, effort.month, effort.year).deliver
        user.sponsored_project_effort_last_emailed = Time.now
        user.save
      end
    end

  end
end
