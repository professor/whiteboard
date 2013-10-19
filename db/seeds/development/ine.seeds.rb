require File.dirname(__FILE__) + '/seeds_helper'
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
set_up_course(course_ine)