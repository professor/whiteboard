FactoryGirl.define do

factory :admin_andy_user, :parent => :user do |p|
  p.login "admin_andy"
  p.email "admin.andy@sv.cmu.edu"
  p.webiso_account "andy@andrew.cmu.edu"
  p.is_staff true
  p.is_admin true
  p.first_name "Admin"
  p.last_name "Andy"
  p.human_name "Admin Andy"
  p.twiki_name "AdminAndy"
end

factory :student_sam_user, :parent => :user do |p|
  p.login "student_sam"
  p.email "student.sam@sv.cmu.edu"
  p.webiso_account "sam@andrew.cmu.edu"
  p.is_student true
  p.is_alumnus false
  p.first_name "Student"
  p.last_name "Sam"
  p.human_name "Student Sam"
  p.twiki_name "StudentSam"
end


factory :student_sam_user_with_registered_courses, :parent => :student_sam_user do
  registered_courses {|registered_courses| [registered_courses.association(:fse), registered_courses.association(:mfse_current_semester)]}
#  after(:build) do
#     registered_courses = [FactoryGirl.build(:fse), FactoryGirl.build(:mfse)]
#   end
end

factory :student_sally_user, :parent => :user do |p|
  p.login "student_sally"
  p.email "student.sally@sv.cmu.edu"
  p.webiso_account "sally@andrew.cmu.edu"
  p.is_student true
  p.is_alumnus false
  p.first_name "Student"
  p.last_name "Sally"
  p.human_name "Student Sally"
  p.twiki_name "StudentSally"
end

factory :faculty_frank_user, :parent => :user do |p|
  p.login "faculty_frank"
  p.email "faculty.frank@sv.cmu.edu"
  p.webiso_account "frank@andrew.cmu.edu"
  p.is_staff true
  p.first_name "Faculty"
  p.last_name "Frank"
  p.human_name "Faculty Frank"
  p.twiki_name "FacultyFrank"
end

factory :faculty_fagan_user, :parent => :user do |p|
  p.login "faculty_fagan"
  p.email "faculty.fagan@sv.cmu.edu"
  p.webiso_account "fagan@andrew.cmu.edu"
  p.is_staff true
  p.first_name "Faculty"
  p.last_name "Fagan"
  p.human_name "Faculty Fagan"
  p.twiki_name "FacultyFagan"
end

factory :contracts_manager_user, :parent => :user do |p|
  p.login "Ngoc Ho"
  p.email "ngoc.ho@sv.cmu.edu"
  p.webiso_account "ngocho@andrew.cmu.edu"
  p.is_staff true
  p.first_name "Ngoc"
  p.last_name "Ho"
  p.human_name "Ngoc Ho"
  p.twiki_name "NgocHo"
end

end