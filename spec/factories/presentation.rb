FactoryGirl.define do
  factory :presentation_for_team_bean_counters, class: Presentation do
    name "Test Presentation for Bean Counters"
    description "Desc"
    task_number "1"
    presentation_date Date.new(2012, 1, 1)
    association :course, :factory => :course
    association :team, :factory => :team_bean_counters
  end
end