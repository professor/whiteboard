class PresentationFeedback < ActiveRecord::Base
  belongs_to :presentation
  belongs_to :evaluator, :class_name => "Person"
  has_many :answers, :class_name => "PresentationFeedbackAnswer", :foreign_key => "feedback_id"
end
