FactoryGirl.define do
  factory :job do |job|
    title       "Project Pandemonium"
  end

  factory :job_with_supervisor_and_employee, :parent => :job do |job|
    association :supervisor, :factory => :job_supervisor
    association :employee, :factory => :job_employee
  end

  factory :job_supervisor do
    association :user, :factory => :faculty_frank_user
  end
  factory :job_employee do
    association :user, :factory => :student_sam_user
  end

end