FactoryGirl.define do

factory :team_deliverable, :parent => :deliverable do |d|
  d.is_team_deliverable true
  d.association :team, :factory => :team_triumphant
end

factory :individual_deliverable, :parent => :deliverable do |d|
  d.is_team_deliverable false
end

end