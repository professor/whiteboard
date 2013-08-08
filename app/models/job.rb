class Job < ActiveRecord::Base

  validates :title, :presence => true

  before_save :update_supervisors_and_employees
  validate :validate_supervisors_and_employees

  has_many :job_supervisors
  has_many :supervisors, :through => :job_supervisors, :source => :user

  has_many :job_employees
  has_many :employees, :through => :job_employees, :source => :user

  belongs_to :sponsored_project

  default_scope order("is_accepting DESC, updated_at DESC")

  scope :active, where('is_closed IS NULL OR is_closed != ?', true)

  scope :part_time_class_of, lambda { |program, year|
    where("is_part_time is TRUE and masters_program = ? and graduation_year = ?", program, year.to_s).order("human_name ASC")
  }

  #When assigning faculty to a job, the user types in a series of strings that then need to be processed
  # :job_supervisors_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the job_supervisors association.
  attr_accessor :supervisors_override
  attr_accessor :employees_override

  attr_accessible :title, :description, :skills_must_haves, :skills_nice_haves,
                  :duration, :sponsored_project_id, :funding_description, :is_accepting,
                  :is_closed, :created_at,
                  :supervisors_override,
                  :employees_override

  include PeopleInACollection

  def validate_supervisors_and_employees
    validate_members :supervisors_override
    validate_members :employees_override
  end

  def update_supervisors_and_employees
    update_collection_members :supervisors_override, :supervisors, :update_log
    update_collection_members :employees_override, :employees, :notify_people
  end

  def notify_people added_users, removed_users
    update_log(added_users, removed_users)
    JobMailer.notify_hr(self, added_users, removed_users)
    JobMailer.notify_added_employees(self, added_users)
    JobMailer.notify_removed_employees(self, removed_users)
  end

  def update_log added_users, removed_users
    self.log = "" if self.log.nil?
    if added_users.present?
      added_users.each { |user| self.log += Time.now.to_s + " - added " + user.human_name + "<br/>" }
    end
    if removed_users.present?
      removed_users.each { |user| self.log += Time.now.to_s + " - removed " + user.human_name + "<br/>" }
    end
  end

  protected

  def self.all_employees
    active_ga_ids = User.where(:is_active => true).
                      where( :is_ga_promised => true).
                      select(:id).
                      collect(&:id)
    current_employee_ids = JobEmployee.select(:user_id).collect(&:user_id)
    all_employee_ids = active_ga_ids.push(*current_employee_ids).uniq.sort
    User.find(all_employee_ids, :order => :is_ga_promised)
  end

end
