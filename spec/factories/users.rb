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
    graduation_year "2014"
    is_part_time true
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
    masters_program "SM"
    graduation_year "2014"
    is_part_time true
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
    organization_name "google"
    teaching_these_courses = [:fse]
    is_part_time true
  end

  factory :faculty_ed, :parent => :user do
    email "faculty.ed@sv.cmu.edu"
    webiso_account "ed@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Ed"
    human_name "Faculty Ed"
    twiki_name "FacultyEd"
    organization_name "yahoo"
  end

  factory :faculty_todd, :parent => :user do
    email "faculty.todd@sv.cmu.edu"
    webiso_account "todd@andrew.cmu.edu"
    is_staff true
    first_name "Faculty"
    last_name "Todd"
    human_name "Faculty Todd"
    twiki_name "FacultyTodd"
    organization_name "yahoo"
  end

  factory :student_shama, :parent => :user do
    email "student.shama@sv.cmu.edu"
    webiso_account "student.shama@andrew.cmu.edu"
    is_student true
    is_alumnus false
    is_admin true
    first_name "Shama"
    last_name "Hoque"
    human_name "Shama Hoque"
    twiki_name "StudentShama"
    masters_program "SE"
    masters_track "Tech"
    organization_name "NestLabs"
    registered_courses = [:fse]
    graduation_year "2013"
    team = [:team_maverick]
  end

  factory :student_rashmi, :parent => :user do
    email "student.rashmi@sv.cmu.edu"
    webiso_account "student.rashmi@andrew.cmu.edu"
    is_student true
    is_alumnus false
    is_admin true
    first_name "Student"
    last_name "Rashmi"
    human_name "Student Rashmi"
    twiki_name "StudentRashmi"
    masters_program "SE"
    masters_track "DM"
    organization_name "HP"
    registered_courses = [:fse]
    graduation_year "2013"
    team = [:team_maverick]
  end

  factory :student_clyde, :parent => :user do
    email "clyde.li@sv.cmu.edu"
    webiso_account "ali@andrew.cmu.edu"
    is_student true
    is_alumnus false
    is_admin false
    first_name "Clyde"
    last_name "Li"
    human_name "Clyde Li"
    twiki_name "ClydeLi"
    masters_program "SM"
    organization_name "Google"
    graduation_year "2013"
    team = [:team_maverick, :team_cooper]
  end

  factory :student_charlie, :parent => :user do
    email "charlie.li@sv.cmu.edu"
    webiso_account "cli@andrew.cmu.edu"
    is_student true
    is_alumnus false
    is_admin false
    first_name "Charlie"
    last_name "Li"
    human_name "Charlie Li"
    twiki_name "CharlieLi"
    masters_program "INI"
    graduation_year "2013"
  end

  factory :student_vidya, :parent => :user do
    email "vidya.pissaye@sv.cmu.edu"
    webiso_account "vpissaye@andrew.cmu.edu"
    is_student true
    is_alumnus false
    is_admin true
    first_name "Vidya"
    last_name "Pissaye"
    human_name "Vidya Pissaye"
    twiki_name "VidyaPissaye"
    masters_program "ECE"
    organization_name "LinkedIn"
    graduation_year "2013"
    team = [:team_maverick, :team_leffingwell]
  end

  factory :alumnus_sunil, :parent => :user do
    email "sunil.pissaye@sv.cmu.edu"
    webiso_account "spissaye@andrew.cmu.edu"
    is_alumnus true
    is_student false
    is_admin true
    first_name "Sunil"
    last_name "Pissaye"
    human_name "Sunil Pissaye"
    twiki_name "SunilPissaye"
    graduation_year "2010"
  end

  factory :alumnus_memo, :parent => :user do
    email "memo.giordano@sv.cmu.edu"
    webiso_account "mgiordano@andrew.cmu.edu"
    is_alumnus true
    is_student false
    is_admin true
    first_name "Memo"
    last_name "Giordano"
    human_name "Memo Giordano"
    twiki_name "Memo Giordano"
    graduation_year "2010"
    organization_name "yahoo"
  end

  factory :alumnus_sean, :parent => :user do
    email "sean.xiao@sv.cmu.edu"
    webiso_account "sxiao@andrew.cmu.edu"
    is_alumnus true
    is_student false
    is_admin true
    first_name "Sean"
    last_name "Xiao"
    human_name "Sean Xiao"
    twiki_name "Sean Xiao"
    graduation_year "2011"
  end


end