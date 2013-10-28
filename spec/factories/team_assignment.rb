FactoryGirl.define do

factory :team_turing_assignment, class: TeamAssignment do
  association :team, :factory => :team_turing
  association :user, :factory => :student_sam_user
end
end