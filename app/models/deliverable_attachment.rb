class DeliverableAttachment < ActiveRecord::Base
  set_table_name "deliverable_attachment_versions"

  belongs_to :submitter, :class_name => "Person", :foreign_key => "submitter_id"
  belongs_to :deliverable

  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
    :path => "deliverables/:deliverable_course_year/:deliverable_course_name/:deliverable_random_hash/submissions/:id/:filename"

  validates_presence_of :submitter, :submission_date

  def before_validation_on_create
    self.submission_date = DateTime.now
  end

end
