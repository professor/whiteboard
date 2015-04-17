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
#    id 143
    email "student.sam@sv.cmu.edu"
    webiso_account "sam@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Student"
    last_name "Sam"
    human_name "Student Sam"
    twiki_name "StudentSam"
#    initialize_with { Person.find_or_initialize_by_id(id)}
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

  factory :teaching_assistant_kyle, :parent => :person do
    email "student.kyle@sv.cmu.edu"
    webiso_account "kyle@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Teaching Assistant"
    last_name "Kyle"
    human_name "Teaching Assistant Kyle"
    twiki_name "TeachingAssistantKyle"
  end

  factory :teaching_assistant_plato, :parent => :person do
    email "student.plato@sv.cmu.edu"
    webiso_account "plato@andrew.cmu.edu"
    is_student true
    is_alumnus false
    first_name "Teaching Assistant"
    last_name "Plato"
    human_name "Teaching Assistant Plato"
    twiki_name "TeachingAssistantPlato"
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

end