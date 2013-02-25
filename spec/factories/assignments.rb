# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :assignment_individual, :parent=>:assignment do
    is_team_deliverable false
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
    sequence(:assignment_order) {|i| i}
  end
end
