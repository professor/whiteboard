Factory.define :course, :class => Course do |c|
  c.name 'Course'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.year
  c.mini 'Both'
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

Factory.define :effort_log_line_item, :class => EffortLogLineItem do |e|
  e.association :course, :factory => :fse
  e.task_type_id 1
  e.effort_log_id 60
end

Factory.define :effort_log, :class => EffortLog do |e|
  e.association :person, :factory => :student_sam
end

Factory.define :page, :class => Page do |p|
  p.title "My page "
  p.url "my_page"
  p.updated_by_user_id 10
  p.tab_one_contents "Lorem Ipsum"
end

Factory.define :person, :class => Person do |p|
  p.is_staff 0
  p.is_student 0
  p.is_admin 0
  p.is_teacher 0
  p.is_active 1
  p.image_uri "/images/mascot.jpg"
  p.email Time.now.to_f.to_s + "@andrew.cmu.edu"
end

Factory.define :scotty_dog_saying do |sds|
  sds.association :user, :factory => :student_sam
  sds.saying "Tartan is my favorite color"
end

Factory.define :sponsored_project_effort, :class => SponsoredProjectEffort do |spe|
  spe.association :sponsored_project_allocation, :factory => :sponsored_project_allocation
  spe.current_allocation 10
  spe.year {Date.today.year}
  spe.month {Date.today.month}
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
 t.person_name "Admin Andy"
 t.person_name2 "Faculty Frank"
 t.person_name3 "Student Sam"
 t.association :course, :factory => :course
end

