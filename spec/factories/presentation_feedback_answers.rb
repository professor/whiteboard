FactoryGirl.define do

  factory :presentation_feedback_answer_with_question_text, class: PresentationFeedbackAnswer do
    rating 3
    association :question, :factory => :presentation_feedback_questions, :text => "q1"
    association :feedback, :factory => :feedback_from_sam
  end

  factory :presentation_feedback_answer_with_question_text_and_comment, class: PresentationFeedbackAnswer do
    rating 3
    comment "Comment 1"
    association :question, :factory => :presentation_feedback_questions, :text => "q1"
    association :feedback, :factory => :feedback_from_sam
  end

end