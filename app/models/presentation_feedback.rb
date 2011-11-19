class PresentationFeedback < ActiveRecord::Base
  belongs_to :user, :class_name => "Person"
  belongs_to :presentation

  GRADE = ['poor','minimally acceptable','good','outstanding']

  def presentation_name
    presentation.name
  end

end
