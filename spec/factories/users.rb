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

  # factories added by Team Maverick
  factory :faculty_allen, :parent => :user do
    email "faculty.allen@sv.cmu.edu"
    webiso_account "allen@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Allen"
    human_name "Faculty Allen"
    twiki_name "FacultyAllen"
  end

  factory :student_shama, :parent => :user do
    email "student.shama@sv.cmu.edu"
    webiso_account "student.shama@andrew.cmu.edu"
    is_student true
    is_admin true
    first_name "Shama"
    last_name "Hoque"
    human_name "Shama Hoque"
    twiki_name "StudentShama"
  end

  factory :student_rashmi, :parent => :user do
    email "student.rashmi@sv.cmu.edu"
    webiso_account "student.rashmi@andrew.cmu.edu"
    is_student true
    is_admin true
    first_name "Student"
    last_name "Rashmi"
    human_name "Student Rashmi"
    twiki_name "StudentRashmi"
  end

  factory :student_clyde, :parent => :user do
    email "clyde.li@sv.cmu.edu"
    webiso_account "ali@andrew.cmu.edu"
    is_student true
    is_admin false
    first_name "Clyde"
    last_name "Li"
    human_name "Clyde Li"
    twiki_name "ClydeLi"
  end

  factory :student_vidya, :parent => :user do
    email "vidya.pissaye@sv.cmu.edu"
    webiso_account "vpissaye@andrew.cmu.edu"
    is_student true
    is_admin true
    first_name "Vidya"
    last_name "Pissaye"
    human_name "Vidya Pissaye"
    twiki_name "VidyaPissaye"
  end

end