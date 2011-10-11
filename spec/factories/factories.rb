#puts "....factories loaded....."
#puts caller.join("\n")

Factory.define :course, :class => Course do |c|
  c.name 'Course'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.year
  c.mini 'Both'
  c.number '96-700'
  c.updated_by_user_id 10
end

Factory.define :curriculum_comment_type do |c|
  c.name 'Comment'
  c.background_color "#FFF499"
end

Factory.define :curriculum_comment do |c|
  c.comment 'This page has a broken link'
  c.url 'https://curriculum.sv.cmu.edu/ppm/task3/submit.html'
end


Factory.define :delayed_system_job do |c|
end

Factory.define :deliverable do |d|
  d.association :course, :factory => :course
  d.association :creator, :factory => :student_sam
end

Factory.define :deliverable_attachment do |d|
  d.association :deliverable, :factory => :deliverable
end


Factory.define :effort_log_line_item, :class => EffortLogLineItem do |e|
  e.association :course, :factory => :fse
  e.task_type_id 1
  e.effort_log_id 60
end

today = Date.today
monday_of_this_week = Date.commercial(today.year, today.cweek, 1)
Factory.define :effort_log, :class => EffortLog do |e|
  e.year monday_of_this_week.cwyear
  e.week_number monday_of_this_week.cweek
  e.association :person, :factory => :student_sam
end

Factory.define :page, :class => Page do |p|
  p.title "My page "
  p.url "my_page"
  p.updated_by_user_id 10
  p.tab_one_contents "Lorem Ipsum"
end

Factory.define :peer_evaluation_learning_objective, :class => PeerEvaluationLearningObjective do |p|
  p.learning_objective "this is my learning objective"
end

Factory.define :peer_evaluation_review, :class => PeerEvaluationReview do |p|
  p.association :team, :factory => :team_triumphant
  p.association :author, :factory => :student_sam
  p.association :recipient, :factory => :student_sally
  p.question "What was this team member's most significant positive contribution to the team?"
  p.answer "Sally was always on time in meetings."
  p.sequence_number 0
end

Factory.define :person, :class => Person do |p|
  p.is_staff 0
  p.is_student 0
  p.is_admin 0
  p.is_teacher 0
  p.is_active 1
  p.image_uri "/images/mascot.jpg"
  p.email Time.now.to_f.to_s + "@andrew.cmu.edu"
#  p.remember_created_at Time.now.to_f.to_s
end


Factory.define :scotty_dog_saying, :class => ScottyDogSaying do |sds|
  sds.association :user, :factory => :student_sam
  sds.saying "Tartan is my favorite color"
end

Factory.define :sponsored_project_effort, :class => SponsoredProjectEffort do |spe|
  spe.association :sponsored_project_allocation, :factory => :sponsored_project_allocation
  spe.current_allocation 10
  spe.year {1.month.ago.year}
  spe.month {1.month.ago.month}
  spe.confirmed false
end

Factory.define :sponsored_project_sponsor, :class => SponsoredProjectSponsor do |sp|
  sp.sequence(:name) {|n| "Sponsor #{n}"}
end

Factory.define :sponsored_project, :class => SponsoredProject do |sp|
  sp.sequence(:name) {|n| "Project #{n}"}
  sp.association :sponsor, :factory => :sponsored_project_sponsor
end

Factory.define :sponsored_project_allocation, :class => SponsoredProjectAllocation do |sp|
  sp.current_allocation 10
  sp.association :person, :factory => :faculty_frank
  sp.association :sponsored_project, :factory => :sponsored_project
  sp.is_archived false
end

Factory.define :suggestion do |sds|
  sds.page "http://rails.sv.cmu.edu"
  sds.comment "This is the best website ever"
end

Factory.define :task_type do |t|
  t.is_staff 0
  t.name "Task name"
  t.is_student 1
  t.description "Task description"
end

Factory.define :team, :class => Team do |t|
t.name "Team"
t.email "team@sv.cmu.edu"
t.tigris_space "http://team.tigris.org/servlets/ProjectDocumentList"
t.twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
t.people {|people| [people.association(:team_member)]}
t.association :course, :factory => :course
end

Factory.define :user, :class => User do |p|
  p.is_staff 0
  p.is_student 0
  p.is_admin 1
  p.is_teacher 0
  p.is_active 1
  p.image_uri "/images/mascot.jpg"
  p.email Time.now.to_f.to_s + "@andrew.cmu.edu"
  p.first_name "user"
  p.last_name "todd"
  p.login "user_todd"
  p.password "ashoifjadslkfjaskl;h"
  p.password_confirmation "ashoifjadslkfjaskl;h"
  p.password_salt "adasdsa"
  p.crypted_password "adasdsaf"
end