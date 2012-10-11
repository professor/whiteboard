# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment do
    name "MyString"
    maximum_score 1.5
    is_team_deliverable false
    due_date "2012-10-03 12:48:24"
    assignment_order 1
    task_number 1
    #association :course #, :factory => :course
  end

  factory :assignment_fse, :parent=>:assignment do
    name "fse assignment 1"
    association :course, :factory => :fse
  end

  factory :assignment_many, :parent=>:assignment do
    course_id 1
    sequence(:name) {|i| "Assignment #{i}"}
    sequence(:assignment_order) {|i| i}
  end
end
