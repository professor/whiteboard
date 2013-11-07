# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade do
    course_id 1
    student_id 1
    assignment_id 1
    score "1.5"
  end

  factory :grade_visible, :parent=>:grade do
    is_student_visible true
  end

  factory :grade_invisible, :parent=>:grade do
    is_student_visible false
  end

  factory :grade_points, :parent=>:grade do
    course_id 1
    student_id 999
    assignment
    is_student_visible false
  end

  factory :grade_letters, :parent=>:grade do
    course_id 1
    score "A"
    student_id 999
    assignment
  end

end

