class DeliverableRevision < ActiveRecord::Base

  belongs_to :submitter, :class_name => "Person", :foreign_key => "submitter_id"
  belongs_to :deliverable

  has_attached_file :revision,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
    :path => "deliverable_submissions/super8/:id/:filename"

  validates_presence_of :submitter

  def before_validation_on_create
    self.submission_date = DateTime.now
  end

end
