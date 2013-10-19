require File.dirname(__FILE__) + '/seeds_helper'
require 'factory_girl'


FactoryGirl.define do

  factory :team_1, :class => Team do
    course_id 1
    name "Project 1"
    email "fall-2012-team-1@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Oscar Sandoval", :oscar)
      team.members << find_user("Prabhjot Singh", :prabhjot)
      team.members << find_user("Shama Rajeev", :shama)
      team.members << find_user("Aristide Niyungeko", :aristide)
      team.members << find_user("Sky Hu", :sky)
      team.members << find_user("Zhipeng Li", :zhipeng)
    }
  end

  factory :team_2, :class => Team do
    course_id 1
    name "Project 2"
    email "fall-2012-team-2@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Owen Chu", :owen)
      team.members << find_user("Clyde Li", :clyde)
      team.members << find_user("Kate Liu", :kate)
      team.members << find_user("David Liu", :david)
      team.members << find_user("Norman Xin", :norman)
    }
  end

  factory :team_3, :class => Team do
    course_id 1
    name "Project 3"
    email "fall-2012-team-3@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Rashmi Devarahalli", :rashmi)
      team.members << find_user("Madhok Shivaratre", :madhok)
      team.members << find_user("Lydian Li", :lydian)
      team.members << find_user("Edward Akoto", :edward)
      team.members << find_user("Vidya Pissaye", :vidya)
    }
  end

  factory :team_4, :class => Team do
    course_id 1
    name "Project 4"
    email "fall-2012-team-4@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("David Pfeffer", :david_p)
      team.members << find_user("Kaushik Gopal", :kaushik)
      team.members << find_user("Mark Hennessy", :mark)
      team.members << find_user("Sean Xiao", :sean)
      team.members << find_user("Sumeet Kumar", :sumeet)
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

  factory :assignment_arch_participation, :parent=>:assignment do
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
      course.teams << FactoryGirl.create(:team_3)
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
set_up_course(course_arch)