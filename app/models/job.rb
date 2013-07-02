  class Job < ActiveRecord::Base

  include PeopleInACollection

  validates :title, :presence => true

  before_save :update_faculty
  validate :validate_supervisors_and_employees

  def validate_supervisors_and_employees
    validate_members :supervisors_override
    validate_members :employees_override
  end


	has_many :job_supervisors
	has_many :supervisors, :through => :job_supervisors, :source => :user

  has_many :job_employees
	has_many :employees, :through => :job_employees, :source => :user

  #When assigning faculty to a job, the user types in a series of strings that then need to be processed
  # :job_supervisors_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the job_supervisors association.
  attr_accessor :supervisors_override
  attr_accessor :employees_override

  attr_accessible :title, :description, :skills_must_haves, :skills_nice_haves,
      						:duration, :funding_source, :funding_oracle_string, :is_accepting,
      						:is_closed,
      						:supervisors_override,
      						:employees_override


  # ..call :faculty, :faculty_assignments_override

  # #When modifying validate_faculty or update_faculty, modify the same code in team.rb
  # #Todo - move to a higher class or try as a mixin

  # def validate_faculty
  #   return "" if faculty_assignments_override.nil?

  #   self.faculty_assignments_override = faculty_assignments_override.select { |name| name != nil && name.strip != "" }
  #   list = map_faculty_strings_to_users(faculty_assignments_override)
  #   list.each_with_index do |user, index|
  #     if user.nil?
  #       self.errors.add(:base, "Person " + faculty_assignments_override[index] + " not found")
  #     end
  #   end
  # end

  def update_faculty
    return "" if supervisors_override.nil?
    self.faculty = []

    self.supervisors_override = supervisors_override.select { |name| name != nil && name.strip != "" }
    list = map_faculty_strings_to_users(self.supervisors_override)
    raise "Error converting supervisors_override to IDs!" if list.include?(nil)
    self.faculty = list
    supervisors_override = nil
  end





end
