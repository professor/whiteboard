# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grading_range do
    grade "MyString"
    minimum_value 1
    course_id 1
  end
end
