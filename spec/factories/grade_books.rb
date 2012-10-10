# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade_book do
    course_id 1
    student_id 1
    assignment_id 1
    score 1.5
  end
  
 factory :grade_book_with_course, :parent=>:grade_book do
    course_id 1
    student_id 999
    assignment
    score 100.0
  end
end
