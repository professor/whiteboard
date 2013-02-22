# For each model in the system, include one factory that creates the bare minimum necessary to save the object.
# In other words, it should pass all validations, but have nothing extra
FactoryGirl.define do

  factory :assignment do
    association :course, :factory => :fse
    maximum_score 20.0
    name "MyString"
    is_team_deliverable false
    due_date "2012-10-03 12:48:24"
    task_number 1
    is_submittable true
  end

  factory :course, class: Course do
    name 'Course'
    semester AcademicCalendar.current_semester
    year Date.today.year
    mini 'Both'
    number '96-700'
    updated_by_user_id 10
    association :grading_rule, :factory => :grading_rule_points
  end


  factory :delayed_system_job do
  end

  factory :deliverable do
    association :assignment, :factory => :assignment
    association :course, :factory => :course
    association :creator, :factory => :student_sally
  end

  factory :deliverable_attachment do
    association :deliverable, :factory => :deliverable
  end


  factory :effort_log_line_item, class: EffortLogLineItem do
    association :course, :factory => :fse
    task_type_id 1
    effort_log_id 60
  end

  today = Date.today
  monday_of_this_week = Date.commercial(today.year, today.cweek, 1)
  factory :effort_log, class: EffortLog do
    year monday_of_this_week.cwyear
    week_number monday_of_this_week.cweek
    association :user, :factory => :student_sam_user
  end

  factory :page, class: Page do
    title "My page "
    url "my_page"
    updated_by_user_id 10
    tab_one_contents "Lorem Ipsum"
  end

  factory :page_comment do
    association :page, :factory => :page
#  association :person, :factory => :student_sam
    comment 'This page has a broken link'
  end

  factory :page_comment_type do
    name 'Comment'
    background_color "#FFF499"
  end

  factory :peer_evaluation_learning_objective, class: PeerEvaluationLearningObjective do
    learning_objective "this is my learning objective"
  end

  factory :peer_evaluation_review, class: PeerEvaluationReview do
    association :team, :factory => :team_triumphant
    association :author, :factory => :student_sam, :email => "student.sam2@sv.cmu.edu", :webiso_account => "ss2@andrew.cmu.edu"
    association :recipient, :factory => :student_sally
    question "What was this team member's most significant positive contribution to the team?"
    answer "Sally was always on time in meetings."
    sequence_number 0
  end

  factory :person, class: Person do
    is_staff 0
    is_student 0
    is_admin 0
    is_active 1
    image_uri "/images/mascot.jpg"
    email Time.now.to_f.to_s + "@andrew.cmu.edu"
#  remember_created_at Time.now.to_f.to_s
  end


  factory :scotty_dog_saying, class: ScottyDogSaying do
    association :user, :factory => :student_sam
    saying "Tartan is my favorite color"
  end

  factory :sponsored_project_effort, class: SponsoredProjectEffort do
    association :sponsored_project_allocation, :factory => :sponsored_project_allocation
    current_allocation 10
    year { 1.month.ago.year }
    month { 1.month.ago.month }
    confirmed false
  end

  factory :sponsored_project_sponsor, class: SponsoredProjectSponsor do
    sequence(:name) { |n| "Sponsor #{n}" }
  end

  factory :sponsored_project, class: SponsoredProject do
    sequence(:name) { |n| "Project #{n}" }
    association :sponsor, :factory => :sponsored_project_sponsor
  end

  factory :sponsored_project_allocation, class: SponsoredProjectAllocation do
    current_allocation 10
    association :user, :factory => :faculty_frank_user
    association :sponsored_project, :factory => :sponsored_project
    is_archived false
  end

  factory :suggestion do
    page "http://rails.sv.cmu.edu"
    comment "This is the best website ever"
  end

  factory :task_type do
    is_staff 0
    name "Task name"
    is_student 1
    description "Task description"
  end

  factory :team, class: Team do
    name "Team"
    email "team@sv.cmu.edu"
    tigris_space "http://team.tigris.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    members { |members| [members.association(:team_member)] }
    association :course, :factory => :course
  end

  factory :user, class: User do
    is_staff 0
    is_student 0
    is_admin 0
    is_active 1
    image_uri "/images/mascot.jpg"
    email Time.now.to_f.to_s + "@andrew.cmu.edu"
#  remember_created_at Time.now.to_f.to_s
  end


  factory :people_search_default, class: PeopleSearchDefault do
  end

  factory :presentation do
    name "Test Presentation"
    description "Desc"
    task_number "1"
    presentation_date Date.new(2011, 1, 1)
    association :course, :factory => :course
    association :team, :factory => :team
  end

  factory :presentation_feedback_questions, class: PresentationQuestion do
    deleted false
  end

  factory :registration do
    course_id 1
    user  
  end

  factory :faculty_assignment, class: FacultyAssignment do
    course_id 1
    user_id 999
  end

  factory :course_fse_with_students, :parent=>:fse do  |c|
    registered_students { |registered_students| [registered_students.association(:team_member)] }
    c.after(:build) {|c| c.registered_students.each  { |s|  FactoryGirl.build(:registration, :course_id=>c.id, :user_id => s.id) } }
  end

end
