require 'factory_girl'

FactoryGirl.define do

  factory :team_cooper, :class => Team do
    course_id 1
    name "Cooper"
    email "fall-2012-team-cooper@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:david_p)
      team.members << FactoryGirl.create(:sky)
      team.members << FactoryGirl.create(:owen)
      team.members << FactoryGirl.create(:sumeet)
      team.members << FactoryGirl.create(:clyde)
    }
  end

  factory :team_cockburn, :class => Team do
    course_id 1
    name "Cockburn"
    email "fall-2012-team-cockburn@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:kaushik)
      team.members << FactoryGirl.create(:rashmi)
      team.members << FactoryGirl.create(:kate)
      team.members << FactoryGirl.create(:norman)
    }
  end

  factory :team_wiegers, :class => Team do
    course_id 1
    name "Wiegers"
    email "fall-2012-team-wiegers@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:oscar)
      team.members << FactoryGirl.create(:madhok)
      team.members << FactoryGirl.create(:lydian)
      team.members << FactoryGirl.create(:edward)
    }
  end

  factory :team_miller, :class => Team do
    course_id 1
    name "Miller"
    email "fall-2012-team-miller@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:shama)
      team.members << FactoryGirl.create(:prabhjot)
      team.members << FactoryGirl.create(:mark)
      team.members << FactoryGirl.create(:zhipeng)
    }
  end

  factory :team_leffingwell, :class => Team do
    course_id 1
    name "Leffingwell"
    email "fall-2012-team-leffingwell@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << FactoryGirl.create(:david)
      team.members << FactoryGirl.create(:vidya)
      team.members << FactoryGirl.create(:aristide)
      team.members << FactoryGirl.create(:sean)
    }
  end

  factory :assignment_elicitation, :parent=>:assignment_team do
    name "Requirements Elicitation"
    maximum_score 20
    due_date "2012-09-09 22:00:00"
    task_number 1
  end

  factory :assignment_envision, :parent=>:assignment_team do
    name "Requirements Envisioning"
    maximum_score 20
    due_date "2012-09-23 22:00:00"
    task_number 2
  end

  factory :assignment_elaboration, :parent=>:assignment_team do
    name "Requirements Elaboration and Validation"
    maximum_score 20
    due_date "2012-10-04 22:00:00"
    task_number 3
  end

  factory :assignment_req_presentation, :parent=>:assignment do
    name "Individual Presentation"
    maximum_score 10
    due_date "2012-10-06 22:00:00"
    task_number 4
  end

  factory :assignment_req_presentation_slides, :parent=>:assignment_team do
    name "Presentation Slides"
    maximum_score 10
    due_date "2012-10-06 22:00:00"
    task_number 4
  end

  factory :assignment_req_participation, :parent=>:assignment_unsubmissible do
    name "Class Participation"
    maximum_score 20
    due_date "2012-10-09 22:00:00"
    task_number 5
  end

  factory :req_2012, :parent => :course do
    name "Requirements Engineering"
    semester "Fall"
    year 2012
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_points)

      course.faculty = []
      course.faculty << FactoryGirl.create(:prof_peraire)

      course.teams = []
      course.teams << FactoryGirl.create(:team_cooper)
      course.teams << FactoryGirl.create(:team_cockburn)
      course.teams << FactoryGirl.create(:team_wiegers)
      course.teams << FactoryGirl.create(:team_miller)
      course.teams << FactoryGirl.create(:team_leffingwell)

      course.assignments = []
      course.assignments << FactoryGirl.create(:assignment_elicitation, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_envision, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_elaboration, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_req_presentation, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_req_presentation_slides, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_req_participation, :course_id=>course.id)
    }
  end

end

course_req = FactoryGirl.create(:req_2012)

course_req.teams.each do |team|
  team.members.each do |team_member|
    FactoryGirl.create(:registration, :course_id=>course_req.id, :user => team_member)
  end
end

course_req.assignments.each do |assignment|
  if assignment.is_team_deliverable
    course_req.teams.each do |team|
      deliverable=FactoryGirl.create(:team_deliverable_simple, :team_id=>team.id, :creator_id=>team.members.first.id, :course_id=>course_req.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.members.first.human_name}_file", :submission_date=>Time.now)
      score = 1+Random.rand(assignment.maximum_score)
      team.members.each do |member|
        grade = FactoryGirl.create(:grade_points, :course_id=>course_req.id, :assignment => assignment, :student_id => member.id)
        grade.score = score
        grade.save
      end
    end
  else
    course_req.registered_students.each do |student|
      deliverable=FactoryGirl.create(:individual_deliverable, :creator_id=>student.id, :course_id=>course_req.id, :assignment_id=>assignment.id)
      FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>student.id, :attachment_file_name=>"#{student.human_name}_file", :submission_date=>Time.now)
      grade = FactoryGirl.create(:grade_points, :course_id=>course_req.id, :assignment => assignment, :student_id => student.id)
      grade.score = 1+Random.rand(assignment.maximum_score)
      grade.save
    end
  end
end

