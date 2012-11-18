require 'factory_girl'

FactoryGirl.define do

  factory :prof_evans, :parent => :person do
    is_staff 1
    first_name "Stuart"
    last_name "Evans"
    human_name "Stuart Evans"
    email "stuart.evans@sv.cmu.edu"
  end

  factory :student_sm_full_time, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SM"
    masters_track "Tech"
    sequence(:email) {|n| "smstudent#{n}@sv.cmu.edu"}
    sequence(:webiso_account) {|n| "smstudent#{n}@andrew.cmu.edu"}
  end

  factory :michael, :parent => :student_sm_full_time do
    id 991
    twiki_name "MichaelJordan"
    first_name "Michael"
    last_name "Jordan"
    human_name "Michael Jordan"
  end

  factory :scottie, :parent => :student_sm_full_time do
    id 992
    twiki_name "ScottiePippen"
    first_name "Scottie"
    last_name "Pippen"
    human_name "Scottie Pippen"
  end

  factory :dennis, :parent => :student_sm_full_time do
    id 993
    twiki_name "DennisRodman"
    first_name "Dennis"
    last_name "Rodman"
    human_name "Dennis Rodman"
  end

  factory :team_bulls, :class => Team do
    name "Bulls"
    email "fall-2012-team-bulls@west.cmu.edu"
    course_id 1
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:michael)
      team.members << FactoryGirl.create(:scottie)
      team.members << FactoryGirl.create(:dennis)
    }
  end

  factory :assignment_indi, :parent=>:assignment do
    name "Individual Assignment"
    maximum_score 30
    due_date "2012-10-12 22:00:00"
    task_number 1
  end

  factory :assignment_indi_parti, :parent=>:assignment_unsubmissible do
    name "Individual Participation"
    maximum_score 20
    task_number 2
  end

  factory :assignment_team_proj, :parent=>:assignment_team do
    name "Team Project Assignment"
    maximum_score 50
    due_date "2012-12-05 22:00:00"
    task_number 3
  end

  factory :ine_2012, :parent => :course do
    name "Innovation and Entrepreneurship"
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_weights)

      course.faculty = []
      course.faculty << FactoryGirl.create(:prof_evans)
      course.teams = []
      course.teams << FactoryGirl.create(:team_bulls)

      course.assignments = []
      course.assignments << FactoryGirl.create(:assignment_indi, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_indi_parti, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_team_proj, :course_id=>course.id)
    }
  end

end

course_ine = FactoryGirl.create(:ine_2012)

course_ine.teams.each do |team|
  team.members.each do |team_member|
    FactoryGirl.create(:registration, :course_id=>course_ine.id, :user => team_member)
  end
end

course_ine.assignments.each do |assignment|
  if assignment.is_team_deliverable
    course_ine.teams.each do |team|
      deliverable=FactoryGirl.create(:team_deliverable_simple, :team_id=>team.id, :creator_id=>team.members.first.id, :course_id=>course_ine.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.members.first.human_name}_file", :submission_date=>Time.now)
      score = 1+Random.rand(assignment.maximum_score)
      team.members.each do |member|
        grade = FactoryGirl.create(:grade_points, :course_id=>course_ine.id, :assignment => assignment, :student_id => member.id)
        grade.score = score
        grade.save
      end
    end
  else
    course_ine.registered_students.each do |student|
      deliverable=FactoryGirl.create(:individual_deliverable, :creator_id=>student.id, :course_id=>course_ine.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>student.id, :attachment_file_name=>"#{student.human_name}_file", :submission_date=>Time.now)
      grade = FactoryGirl.create(:grade_points, :course_id=>course_ine.id, :assignment => assignment, :student_id => student.id)
      grade.score = 1+Random.rand(assignment.maximum_score)
      grade.save
    end
  end
end


