FactoryGirl.define do

  factory :team_deliverable, :parent => :deliverable do
    association :team, :factory => :team_triumphant
    task_number "22"
    DeliverableAttachment.create
    private_note "My private notes"
  end

  factory :individual_deliverable, :parent => :deliverable do
    team_id nil
  end

end