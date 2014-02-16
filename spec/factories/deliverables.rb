FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    association :assignment, :factory => :assignment_team
    association :team, :factory => :team_triumphant
    private_note "My private notes"
  end

  factory :individual_deliverable, :parent => :deliverable do
    team_id nil
  end

  factory :turing_individual_deliverable, :parent => :deliverable do
    team_id nil
    association :creator, :factory => :student_john_user
    association :course, :factory => :fse
  end

  factory :team_deliverable_simple, :class => Deliverable do
    private_note "My private notes"
  end

  factory :team_turing_deliverable_1, :parent => :deliverable do
    association :assignment, :factory => :assignment
    association :team, :factory => :team_turing
    association :course, :factory => :fse
    private_note "My first deliverable"
  end

  factory :team_turing_deliverable_2, :parent => :deliverable do
    association :assignment, :factory => :assignment
    association :team, :factory => :team_turing
    association :course, :factory => :fse
    private_note "My second deliverable"
  end

  factory :team_test_deliverable_1, :parent => :deliverable do
    association :assignment, :factory => :assignment
    association :team, :factory => :team_test
    association :course, :factory => :fse
    association :creator, :factory => :student_Test_user
    private_note "Test team  first deliverable"
  end

  factory :test_individual_deliverable, :parent => :deliverable do
    team_id nil
    association :creator, :factory => :student_sally_user
    association :course, :factory => :fse
  end

  factory :team_ruby_racer_deliverable_1, :parent => :deliverable do
    association :assignment, :factory => :assignment
    association :team, :factory => :team_ruby_racer
    association :course, :factory => :fse
    private_note "Ruby Racer's first deliverable"
  end


end
