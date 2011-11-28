require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :admin_andy, :parent => :person do |p|
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

Factory.define :student_sam, :parent => :person do |p|
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

Factory.define :student_sally, :parent => :person do |p|
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

Factory.define :faculty_frank, :parent => :person do |p|
  p.login "faculty_frank"
  p.email "faculty.frank@sv.cmu.edu"
  p.webiso_account "frank@andrew.cmu.edu"
  p.is_staff true
  p.is_teacher true
  p.first_name "Faculty"
  p.last_name "Frank"
  p.human_name "Faculty Frank"
  p.twiki_name "FacultyFrank"
end

Factory.define :faculty_fagan, :parent => :person do |p|
  p.login "faculty_fagan"
  p.email "faculty.fagan@sv.cmu.edu"
  p.webiso_account "fagan@andrew.cmu.edu"
  p.is_staff true
  p.is_teacher true
  p.first_name "Faculty"
  p.last_name "Fagan"
  p.human_name "Faculty Fagan"
  p.twiki_name "FacultyFagan"
end

Factory.define :strength_quest, :parent => :person do |p|
  p.association :strength1, :factory => :achiever
  p.association :strength2, :factory => :activator
  p.association :strength3, :factory => :adaptability
  p.association :strength4, :factory => :analytical
  p.association :strength5, :factory => :arranger
end

Factory.define :team_member, :parent => :person do |p|
  p.login "team_member"
  p.email "team.member@sv.cmu.edu"
  p.webiso_account "teammember@andrew.cmu.edu"
  p.is_student true
  p.is_alumnus false
  p.first_name "Team"
  p.last_name "Member"
  p.human_name "Team Member"
  p.twiki_name "TeamMember"
end
