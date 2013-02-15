FactoryGirl.define do

  factory :admin_andy_user, :parent => :user do
    id 42
    email "admin.andy@sv.cmu.edu"
    webiso_account "andy@andrew.cmu.edu"
    is_staff true
    is_admin true
    first_name "Admin"
    last_name "Andy"
    human_name "Admin Andy"
    twiki_name "AdminAndy"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :student_sam_user, :parent => :user do
    id 43
    email "student.sam@sv.cmu.edu"
    webiso_account "sam@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sam"
    human_name "Student Sam"
    twiki_name "StudentSam"
    initialize_with { User.find_or_initialize_by_id(id) }
#    initialize_with { User.where(:id => id).first_or_initialize } #Rails 4 way
  end

  factory :student_sally_user, :parent => :user do
    id 44
    email "student.sally@sv.cmu.edu"
    webiso_account "sally@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sally"
    human_name "Student Sally"
    twiki_name "StudentSally"
    initialize_with { User.find_or_initialize_by_id(id) }
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
    id 46
    email "faculty.frank@sv.cmu.edu"
    webiso_account "frank@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Frank"
    human_name "Faculty Frank"
    twiki_name "FacultyFrank"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :faculty_fagan_user, :parent => :user do
    id 47
    email "faculty.fagan@sv.cmu.edu"
    webiso_account "fagan@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Fagan"
    human_name "Faculty Fagan"
    twiki_name "FacultyFagan"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :contracts_manager_user, :parent => :user do
    id 48
    email "ngoc.ho@sv.cmu.edu"
    webiso_account "ngocho@andrew.cmu.edu"
    is_staff true
    first_name "Ngoc"
    last_name "Ho"
    human_name "Ngoc Ho"
    twiki_name "NgocHo"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :student_setech_user, :parent => :user do
    id 49
    email "student.setech@sv.cmu.edu"
    webiso_account "setech@andrew.cmu.edu"
    is_student true
    is_alumnus false
    masters_program "SE"
    masters_track "Tech"
    first_name "Student"
    last_name "Setech"
    human_name "Student Setech"
    twiki_name "StudentSetech"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :student_phd_user, :parent => :user do
    id 50
    email "student.phd@sv.cmu.edu"
    webiso_account "student_phd@andrew.cmu.edu"
    is_student true
    is_alumnus false
    masters_program "PhD"
    first_name "Student"
    last_name "PhD"
    human_name "Student PhD"
    twiki_name "StudentPhd"
    initialize_with { User.find_or_initialize_by_id(id) }
  end

  factory :person_visible_to_setech, :parent => :people_search_default do
    student_staff_group "All"
    program_group "SE"
    track_group "Tech"
  end

end