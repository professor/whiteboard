FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    association :assignment, :factory => :assignment_team
    association :team, :factory => :team_triumphant
    private_note "My private notes"
  end

  factory :individual_deliverable, :parent => :deliverable do
    team_id nil
  end

  factory :team_deliverable_simple, :class => Deliverable do
    private_note "My private notes"
  end

  factory :individual_deliverable1, :parent => :deliverable do
    id 111
    #association :creator_id, :factory => :student_sam_user
    association :assignment, :factory => :assignment_fse_individual
    association :course, :factory => :fse
  end

  factory :individual_deliverable2, :parent => :deliverable do
    id 112
    #association :creator_id, :factory => :student_sally_user
    association :assignment, :factory => :assignment_fse_individual
    association :course, :factory => :fse
  end

  factory :individual_deliverable3, :parent => :deliverable do
    id 113
    association :creator_id, :factory => :student_john_user
    association :assignment, :factory => :assignment_fse_individual2
    association :course, :factory => :fse
  end

  factory :individual_deliverable4, :parent => :deliverable do
    id 114
    association :creator_id, :factory => :student_frank_user
    association :assignment, :factory => :assignment_fse_individual3
    association :course, :factory => :fse
  end

end
