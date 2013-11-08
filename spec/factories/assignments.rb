# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :assignment_individual, :parent=>:assignment do
    is_team_deliverable false
  end

  factory :assignment_team, :parent=>:assignment do
    is_team_deliverable true
    task_number 3
  end

  factory :assignment_unsubmissible, :parent=>:assignment do
    is_submittable false
    due_date ""
  end

  factory :assignment_fse, :parent=>:assignment do
    name "fse assignment 1"
    task_number 1
    association :course, :factory => :fse
  end
  
  factory :assignment_fse2, :parent=>:assignment do
    name "fse assignment 2"
    task_number 2
    association :course, :factory => :fse
  end

  factory :assignment_seq, :parent=>:assignment  do
    course_id 1
    sequence(:name) {|i| "Assignment #{i}"}
    sequence(:maximum_score) {|i| i*3}
    sequence(:assignment_order) {|i| i}
  end

  factory :assignment_fse_individual, :parent=>:assignment do
    name "fse assignment individual"
    task_number 9
    is_team_deliverable false
    association :course, :factory => :fse
  end

  factory :assignment_fse_individual2, :parent=>:assignment do
    name "fse assignment individual 2"
    task_number 2
    is_team_deliverable false
    association :course, :factory => :fse
  end

  factory :assignment_fse_individual3, :parent=>:assignment do
    name "fse assignment individual 3"
    task_number 3
    is_team_deliverable false
    association :course, :factory => :fse
  end

end
