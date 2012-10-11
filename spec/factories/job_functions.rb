# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_function do
    user_id 1
    title "MyString"
    pt_ft_group "MyString"
    student_staff_group "MyString"
    program_group "MyString"
    track_group "MyString"
  end
end
