class Deliverable < ActiveRecord::Base

  belongs_to :submitter, :class_name => "Person", :foreign_key => "submitter_id"
  belongs_to :team
  belongs_to :course

  has_attached_file :deliverable,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
    :path => "deliverable_submissions/super8/:id/:filename"

  def before_save
    # Look up the team this person is on
    self.team = submitter.teams.find(:first, :conditions => ['course_id = ?', course_id])
    self.submission_date = DateTime.now
  end

end
