require 'factory_girl'

FactoryGirl.define do

  factory :team_1, :class => Team do
    course_id 1
    name "1"
    email "fall-2012-team-1@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:oscar)
      team.members << FactoryGirl.create(:prabhjot)
      team.members << FactoryGirl.create(:shama)
      team.members << FactoryGirl.create(:aristide)
      team.members << FactoryGirl.create(:zhipeng)
      team.members << FactoryGirl.create(:edward)
    }
  end

  factory :team_2, :class => Team do
    course_id 1
    name "2"
    email "fall-2012-team-2@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:owen)
      team.members << FactoryGirl.create(:clyde)
      team.members << FactoryGirl.create(:kate)
      team.members << FactoryGirl.create(:david)
      team.members << FactoryGirl.create(:norman)
    }
  end

  factory :team_mastermind, :class => Team do
    course_id 1
    name "Mastermind"
    email "fall-2012-team-3@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:rashmi)
      team.members << FactoryGirl.create(:madhok)
      team.members << FactoryGirl.create(:lydian)
      team.members << FactoryGirl.create(:edward)
      team.members << FactoryGirl.create(:vidya)
    }
  end

  factory :team_4, :class => Team do
    course_id 1
    name "4"
    email "fall-2012-team-4@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:david_p)
      team.members << FactoryGirl.create(:kaushik)
      team.members << FactoryGirl.create(:mark)
      team.members << FactoryGirl.create(:sean)
      team.members << FactoryGirl.create(:sumeet)
    }
  end

  factory :assignment_evaluation, :parent=>:assignment_team do
    name "Compose and Evaluate an Architecture"
    maximum_score 20
    due_date "2012-11-13 23:59:59"
    task_number 1
  end

  factory :assignment_analyzation, :parent=>:assignment_team do
    name "Analyze an Architecture"
    maximum_score 20
    due_date "2012-11-20 23:59:59"
    task_number 2
  end

  factory :assignment_realization, :parent=>:assignment_team do
    name "Realize and Evaluate an Architecture"
    maximum_score 35
    due_date "2012-11-27 23:59:59"
    task_number 3
  end

  factory :assignment_report, :parent=>:assignment_team do
    name "Write a Paper and a Technical Report"
    maximum_score 15
    due_date "2012-12-04 23:59:59"
    task_number 4
  end

  factory :assignment_arch_participation, :parent=>:assignment_team do
    name "Individual Participation"
    maximum_score 7
    due_date "2012-12-04 23:59:59"
    task_number 5
  end

  factory :arch_2012, :parent => :course do
    name "Architecture and Design"
    semester "Fall"
    year 2012
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_points)

      course.faculty = []
      course.faculty << FactoryGirl.create(:prof_zhang)

      course.teams = []
      course.teams << FactoryGirl.create(:team_1)
      course.teams << FactoryGirl.create(:team_2)
      course.teams << FactoryGirl.create(:team_mastermind)
      course.teams << FactoryGirl.create(:team_4)

      course.assignments = []
      course.assignments << FactoryGirl.create(:assignment_evaluation, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_analyzation, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_realization, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_report, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_arch_participation, :course_id=>course.id)
    }
  end

end

course_arch = FactoryGirl.create(:arch_2012)

course_arch.teams.each do |team|
  team.members.each do |team_member|
    FactoryGirl.create(:registration, :course_id=>course_arch.id, :user => team_member)
  end
end

course_arch.assignments.each do |assignment|
  if assignment.is_team_deliverable
    course_arch.teams.each do |team|
      deliverable=FactoryGirl.create(:team_deliverable_simple, :team_id=>team.id, :creator_id=>team.members.first.id, :course_id=>course_arch.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.members.first.human_name}_file", :submission_date=>Time.now)
      score = 1+Random.rand(assignment.maximum_score)
      team.members.each do |member|
        grade = FactoryGirl.create(:grade_points, :course_id=>course_arch.id, :assignment => assignment, :student_id => member.id)
        grade.score = score
        grade.save
      end
    end
  else
    course_arch.registered_students.each do |student|
      deliverable=FactoryGirl.create(:individual_deliverable, :creator_id=>student.id, :course_id=>course_arch.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>student.id, :attachment_file_name=>"#{student.human_name}_file", :submission_date=>Time.now)
      grade = FactoryGirl.create(:grade_points, :course_id=>course_arch.id, :assignment => assignment, :student_id => student.id)
      grade.score = 1+Random.rand(assignment.maximum_score)
      grade.save
    end
  end
end

