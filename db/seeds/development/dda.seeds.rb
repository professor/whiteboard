require File.dirname(__FILE__) + '/seeds_helper'
require 'factory_girl'


FactoryGirl.define do

  factory :team_gryffindor, :class => Team do
    course_id 1
    name "Gryffindor"
    email "fall-2012-team-gryffindor@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Harry Potter", :harry)
      team.members << find_user("Ron Weasley", :ron)
      team.members << find_user("Hermione Granger", :hermione)
      team.members << find_user("Neville Longbottom", :neville)
    }
  end

  factory :team_slytherin, :class => Team do
    course_id 1
    name "Slytherin"
    email "fall-2012-team-slytherin@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Draco Malfoy", :draco)
    }
  end

  factory :assignment_charm, :parent=>:assignment_team do
    name "Patronous Charm"
    maximum_score 80
    due_date "2012-11-06 23:59:59"
    task_number 1
  end

  factory :assignment_dda_participation, :parent=>:assignment_unsubmissible do
    name "Class Participation"
    maximum_score 10
    due_date "2012-11-06 22:00:00"
    task_number 3
  end

  factory :grading_rule_dda, :parent=>:grading_rule do
    grade_type "points"
    is_nomenclature_deliverable true
  end

  factory :dda_2012, :parent => :course do
    name "Defence against the Dark Arts"
    semester "Fall"
    year 2012
    after(:create) { |course|
      course.grading_rule = FactoryGirl.create(:grading_rule_dda)

      course.faculty = []
      course.faculty << FactoryGirl.create(:prof_snape)

      course.teams = []
      course.teams << FactoryGirl.create(:team_gryffindor)
      course.teams << FactoryGirl.create(:team_slytherin)

      course.assignments = []
      course.assignments << FactoryGirl.create(:assignment_charm, :course_id=>course.id)
      course.assignments << FactoryGirl.create(:assignment_dda_participation, :course_id=>course.id)
    }
  end

end

course_dda = FactoryGirl.create(:dda_2012)
set_up_course(course_dda)

team = Team.find_by_name("Gryffindor")
assignment = Assignment.find_by_name("Patronous Charm")
team.members.each do |member|
  grade = Grade.get_grade(course_dda.id, assignment.id, member.id)
  grade.destroy
end

deliverable = Deliverable.find_by_assignment_id_and_team_id(assignment.id, team.id)
attachment = FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.name}_old_file", :submission_date=>Time.now)
attachment.submission_date = assignment.due_date
attachment.save