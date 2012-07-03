FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    is_team_deliverable true
    association :team, :factory => :team_triumphant
  end

  factory :individual_deliverable, :parent => :deliverable do
    is_team_deliverable false
  end

end