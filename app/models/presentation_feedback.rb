class PresentationFeedback < ActiveRecord::Base
  belongs_to :user, :class_name => "Person"
  belongs_to :presentation

  validates_presence_of :presentation_id, :user_id, :content, :organization, :visual, :delivery

  GRADE = ['poor','minimally acceptable','good','outstanding']



end
