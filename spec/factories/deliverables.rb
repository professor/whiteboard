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
    association :creator_id, :factory => :student_sam_user
    association :assignment, :factory => :assignment_fse_individual
    association :course, :factory => :fse
  end

  factory :individual_deliverable2, :parent => :deliverable do
    id 112
    association :creator_id, :factory => :student_sally_user
    association :assignment, :factory => :assignment_fse_individual
    association :course, :factory => :fse
  end

  factory :deliverable1,:parent=>:deliverable do
    id 211
    #association :creator_id,:factory => :student_sally_user
    association :assignment,:factory=>:assignment1_fse
    association :course, :factory => :fse_fall_2011
  end

  factory :deliverable2,:parent=>:deliverable do
    id 212
    #association :creator_id,:factory=>:student_sally_user
    association :assignment,:factory=>:assignment2_fse
    association :course, :factory => :fse_fall_2011
  end

  factory :deliverable3,:parent=>:deliverable do
    id 213
    #association :creator_id,:factory=>:student_sally_user
    association :assignment,:factory=>:assignment3_fse
    association :course, :factory => :fse_fall_2011
  end
end
