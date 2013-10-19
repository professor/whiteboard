require File.dirname(__FILE__) + '/seeds_helper'
require 'factory_girl'


FactoryGirl.define do

  factory :team_3amigos, :class => Team do
    course_id 1
    name "3 Amigos"
    email "fall-2012-team-3-amigos@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Owen Chu", :owen)
      team.members << find_user("Madhok Shivaratre", :madhok)
      team.members << find_user("David Liu", :david)
    }
  end

  factory :team_leopard, :class => Team do
    course_id 1
    name "Leopard"
    email "fall-2012-team-leopard@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Prabhjot Singh", :prabhjot)
      team.members << find_user("Lydian Lee", :lydian)
      team.members << find_user("Kate Liu", :kate)
    }
  end

  factory :team_awesome, :class => Team do
    course_id 1
    name "Awesome"
    email "fall-2012-team-awesome@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Oscar Sandoval", :oscar)
      team.members << find_user("Aristide Niyungeko", :aristide)
      team.members << find_user("Sky Hu", :sky)
      team.members << find_user("Norman Xin", :norman)
    }
  end

  factory :team_ramrod, :class => Team do
    course_id 1
    name "Ramrod"
    email "fall-2012-team-ramrod@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("David Pfeffer", :david_p)
      team.members << find_user("Kaushik Gopal", :kaushik)
      team.members << find_user("Edward Akoto", :edward)
      team.members << find_user("Zhipeng Li", :zhipeng)
    }
  end

  factory :team_maverick, :class => Team do
    course_id 1
    name "Maverick"
    email "fall-2012-team-maverick@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Rashmi Devarahalli", :rashmi)
      team.members << find_user("Clyde Li", :clyde)
      team.members << find_user("Shama Rajeev", :shama)
      team.members << find_user("Vidya Pissaye", :vidya)
    }
  end

  factory :team_curiosity, :class => Team do
    course_id 1
    name "Curiosity"
    email "fall-2012-team-curiosirt@west.cmu.edu"
    after(:create) { |team|
      team.members = []
      team.members << find_user("Sean Xiao", :sean)
      team.members << find_user("Mark Hennessy", :mark)
      team.members << find_user("Sumeet Kumar", :sumeet)
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
      course.teams << FactoryGirl.create(:team_awesome)
      course.teams << FactoryGirl.create(:team_ramrod)
      course.teams << FactoryGirl.create(:team_maverick)
      course.teams << FactoryGirl.create(:team_curiosity)

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
set_up_course(course_fse)