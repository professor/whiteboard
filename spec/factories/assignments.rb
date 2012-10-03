# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment do
    name "MyString"
    maximum_score 1.5
    is_team_deliverable false
    due_date "2012-10-03 12:48:24"
    course_id 1
    assignment_order 1
    task_number 1
  end
end
