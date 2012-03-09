class PresentationFeedbackAnswer < ActiveRecord::Base
  belongs_to :feedback, :class_name => "PresentationFeedback", :foreign_key => "feedback_id"
  belongs_to :question, :class_name => "PresentationQuestion", :foreign_key => "question_id"

  accepts_nested_attributes_for :feedback
  validates_presence_of :rating

end
