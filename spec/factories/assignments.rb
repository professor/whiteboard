# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment do
    name "MyString"
    maximum_score 20.0
    is_team_deliverable false
    due_date "2012-10-03 12:48:24"
    task_number 1
    is_submittable true
    sequence(:assignment_order) {|i| i}
    course_id 1
  end

  factory :assignment_team, :parent=>:assignment do
    is_team_deliverable true
  end

  factory :assignment_unsubmissible, :parent=>:assignment do
    is_submittable false
    due_date ""
  end

  factory :assignment_fse, :parent=>:assignment do
    name "fse assignment 1"
    association :course, :factory => :fse
  end

  factory :assignment_seq, :parent=>:assignment  do
    course_id 1
    sequence(:name) {|i| "Assignment #{i}"}
    sequence(:maximum_score) {|i| i*3}
  end
end
