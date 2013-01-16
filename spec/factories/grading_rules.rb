# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grading_rule do
    A_grade_min 94
    A_minus_grade_min 90
    B_plus_grade_min  87
    B_grade_min 83
    B_minus_grade_min 80
    C_plus_grade_min 78
    C_grade_min 74
    C_minus_grade_min 70
    course_id 1
    is_nomenclature_deliverable false
  end

  factory :grading_rule_points, :parent=>:grading_rule do
    grade_type "points"
  end

  factory :grading_rule_weights, :parent=>:grading_rule do
    grade_type "weights"
  end
end
