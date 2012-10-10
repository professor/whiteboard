# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade_book do
    course_id 1
    student_id 1
    assignment_id 1
    score 1.5
  end
end
