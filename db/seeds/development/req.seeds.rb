require File.dirname(__FILE__) + '/seeds_helper'
require 'factory_girl'


FactoryGirl.define do

  factory :team_cooper, :class => Team do
    course_id 1
    name "Cooper"
    email "fall-2012-team-cooper@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("David Pfeffer", :david_p)
      team.members << find_user("Sky Hu", :sky)
      team.members << find_user("Owen Chu", :owen)
      team.members << find_user("Sumeet Kumar", :sumeet)
      team.members << find_user("Clyde Li", :clyde)
    }
  end

  factory :team_cockburn, :class => Team do
    course_id 1
    name "Cockburn"
    email "fall-2012-team-cockburn@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Kaushik Gopal", :kaushik)
      team.members << find_user("Rashmi Devarahalli", :rashmi)
      team.members << find_user("Kate Liu", :kate)
      team.members << find_user("Norman Xin", :norman)
    }
  end

  factory :team_wiegers, :class => Team do
    course_id 1
    name "Wiegers"
    email "fall-2012-team-wiegers@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Oscar Sandoval", :oscar)
      team.members << find_user("Madhok Shivaratre", :madhok)
      team.members << find_user("Lydian Li", :lydian)
      team.members << find_user("Edward Akoto", :edward)
    }
  end

  factory :team_miller, :class => Team do
    course_id 1
    name "Miller"
    email "fall-2012-team-miller@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Shama Rajeev", :shama)
      team.members << find_user("Prabhjot Singh", :prabhjot)
      team.members << find_user("Mark Hennessy", :mark)
      team.members << find_user("Zhipeng Li", :zhipeng)
    }
  end

  factory :team_leffingwell, :class => Team do
    course_id 1
    name "Leffingwell"
    email "fall-2012-team-leffingwell@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("David Liu", :david)
      team.members << find_user("Vidya Pissaye", :vidya)
      team.members << find_user("Aristide Niyungeko", :aristide)
      team.members << find_user("Sean Xiao", :sean)
    }
  end

  factory :assignment_elicitation, :parent=>:assignment_team do
    name "Elicitation"
    maximum_score 20
    due_date "2012-09-09 22:00:00"
    task_number 1
  end

  factory :assignment_envision, :parent=>:assignment_team do
    name "Envisioning"
    maximum_score 20
    due_date "2012-09-23 22:00:00"
    task_number 2
  end

  factory :assignment_elaboration, :parent=>:assignment_team do
    name "Elaboration and Validation"
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

  factory :grading_rule_req, :parent=>:grading_rule do
    grade_type "points"
    is_nomenclature_deliverable true
  end


  factory :req_2012, :parent => :course do
    name "Requirements Engineering"
    semester "Fall"
    year 2012
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_req)

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
set_up_course(course_req)

team_cooper = Team.find_by_name("Cooper")
assignment_validation = Assignment.find_by_name("Elaboration and Validation")
team_cooper.members.each do |member|
  grade = Grade.get_grade(course_req.id, assignment_validation.id, member.id)
  grade.destroy
end

deliverable = Deliverable.find_by_assignment_id_and_team_id(assignment_validation.id, team_cooper.id)
attachment = FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team_cooper.members.first.id, :attachment_file_name=>"#{team_cooper.name}_old_file", :submission_date=>Time.now)
attachment.submission_date = assignment_validation.due_date
attachment.save