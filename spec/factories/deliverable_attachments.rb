FactoryGirl.define do

  factory :attachment_1, :parent => :deliverable_attachment do
    submitter_id 1
    deliverable_id 1
    submission_date DateTime.now
    association :deliverable, :factory => :team_deliverable
    association :submitter, :factory => :student_john_user
  end

end