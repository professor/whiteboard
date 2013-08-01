class JobEmployee < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  delegate :human_name, :to => :user
  delegate :twiki_name, :to => :user

  protected
  def self.get_projects_for_user(user_id)
      job_ids = JobEmployee.
                  where(:user_id => user_id).
                  select(:job_id).
                  collect(&:job_id)
     Job.find(job_ids).collect(&:title).join(", ")
  end
  def self.get_supervisors_for_user(user_id)
      job_ids = JobEmployee.
                where(:user_id => user_id).
                select(:job_id).
                collect(&:job_id)
      supervisor_ids = JobSupervisor.where(:job_id => job_ids).collect(&:user_id)
      User.find(supervisor_ids)
  end

end
