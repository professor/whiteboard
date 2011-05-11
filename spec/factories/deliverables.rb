require File.join(Rails.root,'spec','factories','factories.rb')

Factory.define :team_deliverable, :parent => :deliverable do |d|
  d.is_team_deliverable true
  d.association :team, :factory => :team_triumphant
end

Factory.define :individual_deliverable, :parent => :deliverable do |d|
  d.is_team_deliverable false
end

