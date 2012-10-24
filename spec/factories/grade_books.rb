# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade do
    course_id 1
    student_id 1
    assignment_id 1
    score 1.5
  end
  
 factory :grade_with_course, :parent=>:grade do
    course_id 1
    sequence(:score) {|i| i*5 } 
    student_id 999
    assignment
 end
end
