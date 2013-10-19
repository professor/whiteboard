class JobSupervisor < ActiveRecord::Base
  attr_accessible :job_id, :user_id
  belongs_to :job
  belongs_to :user
  delegate :human_name, :to => :user
  delegate :twiki_name, :to => :user

  protected
  def self.get_supervisors(jobs)
      supervisor_ids = JobSupervisor.
                            where(:job_id => jobs.collect(&:id)).
                            collect(&:user_id)
      User.find(supervisor_ids)
  end

end
