FactoryGirl.define do

  factory :admin_andy_user, :parent => :user do
    email "admin.andy@sv.cmu.edu"
    webiso_account "andy@andrew.cmu.edu"
    is_staff true
    is_admin true
    first_name "Admin"
    last_name "Andy"
    human_name "Admin Andy"
    twiki_name "AdminAndy"
  end

  factory :student_sam_user, :parent => :user do
    email "student.sam@sv.cmu.edu"
    webiso_account "sam@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sam"
    human_name "Student Sam"
    twiki_name "StudentSam"
  end

  factory :student_sally_user, :parent => :user do
    email "student.sally@sv.cmu.edu"
    webiso_account "sally@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sally"
    human_name "Student Sally"
    twiki_name "StudentSally"
  end

  factory :student_john_user, :parent => :user do
    sequence(:email) {|i| "student_john#{i}@sv.cmu.edu"}
    sequence(:webiso_account) {|i| "student_john#{i}@andrew.cmu.edu"}
    sequence(:human_name) {|i| "student_John#{i}"}
    sequence(:first_name) {|i| "student_John#{i}"}
    sequence(:last_name) {|i| "student_John#{i}"}
    sequence(:twiki_name) {|i| "student_John#{i}"}
    is_student true
    is_alumnus false
  end

  factory :faculty_frank_user, :parent => :user do
    email "faculty.frank@sv.cmu.edu"
    webiso_account "frank@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Frank"
    human_name "Faculty Frank"
    twiki_name "FacultyFrank"
  end

  factory :faculty_fagan_user, :parent => :user do
    email "faculty.fagan@sv.cmu.edu"
    webiso_account "fagan@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Fagan"
    human_name "Faculty Fagan"
    twiki_name "FacultyFagan"
  end

  factory :contracts_manager_user, :parent => :user do
    email "ngoc.ho@sv.cmu.edu"
    webiso_account "ngocho@andrew.cmu.edu"
    is_staff true
    first_name "Ngoc"
    last_name "Ho"
    human_name "Ngoc Ho"
    twiki_name "NgocHo"
  end



end