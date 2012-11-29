require 'factory_girl'

FactoryGirl.define do

  factory :team_bulls, :class => Team do
    course_id 1
    name "Bulls"
    email "fall-2012-team-bulls@west.cmu.edu"
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
    semester "Fall"
    year 2012
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


