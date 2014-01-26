FactoryGirl.define do

  factory :team_turing_assignment, class: TeamAssignment do
    association :team, :factory => :team_turing
    association :user, :factory => :student_sam_user
  end

  factory :team_test_assignment, class: TeamAssignment do
    association :team, :factory => :team_test
    association :user, :factory => :student_john_user
  end

  factory :team_ruby_racer_assignment, class: TeamAssignment do
    association :team, :factory => :team_ruby_racer
    association :user, :factory => :student_sally_user
  end

end
