class Job < ActiveRecord::Base

  validates :title, :presence => true

  before_save :update_supervisors_and_employees
  validate :validate_supervisors_and_employees

  has_many :job_supervisors
  has_many :supervisors, :through => :job_supervisors, :source => :user

  has_many :job_employees
  has_many :employees, :through => :job_employees, :source => :user

  belongs_to :sponsored_project

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
    update_collection_members :supervisors_override, :supervisors
    update_collection_members :employees_override, :employees, :notify_people
  end

  def notify_people added_people, removed_people
    JobMailer.notify_hr(self, added_people, removed_people).deliver
    JobMailer.notify_added_employees(self, added_people).deliver
    JobMailer.notify_removed_employees(self, removed_people).deliver
  end

end
