#puts "....factories loaded....."
#puts caller.join("\n")


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

Factory.define :deliverable_attachment do |d|
  d.association :deliverable, :factory => :deliverable
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