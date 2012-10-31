FactoryGirl.define do

  factory :admin_andy, :parent => :person do
    email "admin.andy@sv.cmu.edu"
    webiso_account "andy@andrew.cmu.edu"
    is_staff true
    is_admin true
    first_name "Admin"
    last_name "Andy"
    human_name "Admin Andy"
    twiki_name "AdminAndy"
  end

  factory :student_sam, :parent => :person do
#    id 42
    email "student.sam@sv.cmu.edu"
    webiso_account "sam@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sam"
    human_name "Student Sam"
    twiki_name "StudentSam"
#    initialize_with { Person.find_or_create_by_id(id)}
  end

  factory :student_sally, :parent => :person do
    email "student.sally@sv.cmu.edu"
    webiso_account "sally@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sally"
    human_name "Student Sally"
    twiki_name "StudentSally"
  end

  factory :faculty_frank, :parent => :person do
    email "faculty.frank@sv.cmu.edu"
    webiso_account "frank@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Frank"
    human_name "Faculty Frank"
    twiki_name "FacultyFrank"
  end

  factory :faculty_fagan, :parent => :person do
    email "faculty.fagan@sv.cmu.edu"
    webiso_account "fagan@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Fagan"
    human_name "Faculty Fagan"
    twiki_name "FacultyFagan"
  end

  factory :strength_quest, :parent => :person do
    association :strength1, :factory => :achiever
    association :strength2, :factory => :activator
    association :strength3, :factory => :adaptability
    association :strength4, :factory => :analytical
    association :strength5, :factory => :arranger
  end

  factory :team_member, :parent => :person do
    email "team.member@sv.cmu.edu"
    webiso_account "teammember@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Team"
    last_name "Member"
    human_name "Team Member"
    twiki_name "TeamMember"
  end

  factory :student_setech, :parent => :person do
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
#    initialize_with { Person.find_or_create_by_id(id)}
  end

  factory :student_phd, :parent => :person do
    email "student.phd@sv.cmu.edu"
    webiso_account "student_phd@andrew.cmu.edu"
    is_student true
    is_alumnus false
    masters_program "PhD"
    first_name "Student"
    last_name "PhD"
    human_name "Student PhD"
    twiki_name "StudentPhd"
#    initialize_with { Person.find_or_create_by_id(id)}
  end

  factory :person_visible_to_setech, :parent => :people_search_default do
    student_staff_group "All"
    program_group "SE"
    track_group "Tech"
  end

end