require 'factory_girl'

FactoryGirl.define do

  factory :prof, :parent => :person do
    is_staff 1
  end

  factory :prof_liu, :parent => :prof do
    first_name "YC"
    last_name "Liu"
    human_name "YC Liu"
    email "kate.liu@sv.cmu.edu"
  end

  factory :prof_singh, :parent => :prof do
    first_name "P"
    last_name "Singh"
    human_name "P Singh"
    email "prabhjot.singh@sv.cmu.edu"
  end

  factory :prof_lee, :parent => :prof do
    first_name "TY"
    last_name "Lee"
    human_name "TY Lee"
    email "lydian.lee@sv.cmu.edu"
  end

  factory :student_se_full_time, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    sequence(:email) {|n| "sestudent#{n}@sv.cmu.edu"}
    sequence(:webiso_account) {|n| "sestudent#{n}@andrew.cmu.edu"}
  end

  factory :owen, :parent => :student_se_full_time do
    id 994
    twiki_name "OwenChu"
    first_name "Owen"
    last_name "Chu"
    human_name "Owen Chu"
  end

  factory :david, :parent => :student_se_full_time do
    id 995
    twiki_name "DavidLiu"
    first_name "David"
    last_name "Liu"
    human_name "David Liu"
  end

  factory :madhok, :parent => :student_se_full_time do
    id 996
    twiki_name "MadhokShivaratre"
    first_name "Madhok"
    last_name "Shivaratre"
    human_name "Madhok Shivaratre"
  end

  factory :team_3amigos, :class => Team do
    name "3 Amigos"
    email "fall-2012-team-3-amigos@west.cmu.edu"
    course_id 1
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:owen)
      team.members << FactoryGirl.create(:david)
      team.members << FactoryGirl.create(:madhok)
    }
  end

  factory :prabhjot, :parent => :student_se_full_time do
    id 997
    twiki_name "PrabhjotSingh"
    first_name "Prabhjot"
    last_name "Singh"
    human_name "Prabhjot Singh"
  end

  factory :lydian, :parent => :student_se_full_time do
    id 998
    twiki_name "LydianLee"
    first_name "Lydian"
    last_name "Lee"
    human_name "Lydian Lee"
  end

  factory :kate, :parent => :student_se_full_time do
    id 999
    twiki_name "KateLiu"
    first_name "Kate"
    last_name "Liu"
    human_name "Kate Liu"
  end

  factory :team_leopard, :class => Team do
    name "Leopard"
    email "fall-2012-team-leopard@west.cmu.edu"
    course_id 1
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:prabhjot)
      team.members << FactoryGirl.create(:lydian)
      team.members << FactoryGirl.create(:kate)
    }
  end

  factory :assignment_team_prep, :parent=>:assignment_team do
    name "Preparation"
    maximum_score 5
    due_date "2012-09-02 22:00:00"
    task_number 1
  end

  factory :assignment_team_ite_0, :parent=>:assignment_team do
    name "Iteration 0"
    maximum_score 10
    due_date "2012-09-23 22:00:00"
    task_number 2
  end

  factory :assignment_team_ite_1, :parent=>:assignment_team do
    name "Iteration 1"
    maximum_score 10
    due_date "2012-10-14 22:00:00"
    task_number 3
  end

  factory :assignment_team_ite_2, :parent=>:assignment_team do
    name "Iteration 2"
    maximum_score 10
    due_date "2012-11-11 22:00:00"
    task_number 4
  end

  factory :assignment_team_ite_3, :parent=>:assignment_team do
    name "Iteration 3"
    maximum_score 10
    due_date "2012-12-02 22:00:00"
    task_number 5
  end

  factory :assignment_team_retro, :parent=>:assignment_team do
    name "Retrospective"
    maximum_score 5
    due_date "2012-12-08 22:00:00"
    task_number 6
  end

  factory :assignment_indi_brief_1, :parent=>:assignment do
    name "Briefing 1"
    maximum_score 4
    due_date "2012-09-02 22:00:00"
    task_number 1
  end

  factory :assignment_indi_rails, :parent=>:assignment do
    name "Learning Rails"
    maximum_score 15
    due_date "2012-09-23 22:00:00"
    task_number 2
  end

  factory :assignment_indi_eval, :parent=>:assignment do
    name "Peer Evaluations"
    maximum_score 4
    due_date "2012-10-14 22:00:00"
    task_number 3
  end

  factory :assignment_indi_brief_2, :parent=>:assignment do
    name "Briefing 2"
    maximum_score 4
    due_date "2012-11-11 22:00:00"
    task_number 4
  end

  factory :assignment_effort_log, :parent=>:assignment_unsubmissible do
    name "Effort Logs"
    maximum_score 5
    task_number 0
  end

  factory :assignment_participation, :parent=>:assignment_unsubmissible do
    name "Participation"
    maximum_score 5
    task_number 0
  end

  factory :assignment_presentation, :parent=>:assignment_unsubmissible do
    name "Final Presentation"
    maximum_score 10
    task_number 5
  end

  factory :fse_2012, :parent => :fse do
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_points)

      course.faculty = []
      course.faculty << FactoryGirl.create(:prof_liu)
      course.faculty << FactoryGirl.create(:prof_singh)
      course.faculty << FactoryGirl.create(:prof_lee)

      course.teams = []
      course.teams << FactoryGirl.create(:team_3amigos)
      course.teams << FactoryGirl.create(:team_leopard)

      course.assignments = []
      course.assignments << FactoryGirl.create(:assignment_team_prep, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_indi_brief_1, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_ite_0, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_indi_rails, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_ite_1, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_indi_eval, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_ite_2, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_indi_brief_2, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_ite_3, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_retro, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_effort_log, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_participation, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_presentation, :course_id=>course.id)
    }
  end

end

course_fse = FactoryGirl.create(:fse_2012)

course_fse.teams.each do |team|
  team.members.each do |team_member|
    FactoryGirl.create(:registration, :course_id=>course_fse.id, :user => team_member)
  end
end

course_fse.assignments.each do |assignment|
  if assignment.is_team_deliverable
    course_fse.teams.each do |team|
      deliverable=FactoryGirl.create(:team_deliverable_simple, :team_id=>team.id, :creator_id=>team.members.first.id, :course_id=>course_fse.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.members.first.human_name}_file", :submission_date=>Time.now)
      score = 1+Random.rand(assignment.maximum_score)
      team.members.each do |member|
        grade = FactoryGirl.create(:grade_points, :course_id=>course_fse.id, :assignment => assignment, :student_id => member.id)
        grade.score = score
        grade.save
      end
    end
  else
    course_fse.registered_students.each do |student|
      deliverable=FactoryGirl.create(:individual_deliverable, :creator_id=>student.id, :course_id=>course_fse.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>student.id, :attachment_file_name=>"#{student.human_name}_file", :submission_date=>Time.now)
      grade = FactoryGirl.create(:grade_points, :course_id=>course_fse.id, :assignment => assignment, :student_id => student.id)
      grade.score = 1+Random.rand(assignment.maximum_score)
      grade.save
    end
  end
end

