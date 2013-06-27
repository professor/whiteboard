class Job < ActiveRecord::Base

	has_many :job_supervisors
	has_many :supervisors, :through => :job_supervisors, :source => :user

  has_many :job_employees
	has_many :employees, :through => :job_employees, :source => :user

end
