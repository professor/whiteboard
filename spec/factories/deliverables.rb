FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    association :assignment, :factory => :assignment_team
    association :team, :factory => :team_triumphant
    private_note "My private notes"
  end

  factory :individual_deliverable, :parent => :deliverable do
    team_id nil
  end

end
