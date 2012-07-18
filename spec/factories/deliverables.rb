FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    association :team, :factory => :team_triumphant
  end

  factory :individual_deliverable, :parent => :deliverable do
    team_id nil
  end

end