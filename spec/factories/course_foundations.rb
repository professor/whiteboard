require_relative "../lib/course_helper"

FactoryGirl.define do
  factory :foundations_assignment_1, :parent => :assignment do
    task_number nil
    title 'Effort Logs'
    team_deliverable false
    due_date nil
    weight 5
    can_submit false
  end

  factory :foundations_assignment_2, :parent => :assignment do
    task_number nil
    title 'Participation'
    team_deliverable false
    due_date nil
    weight 5
    can_submit false
  end

  factory :foundations_assignment_3, :parent => :assignment do
    task_number 1
    title 'Preparation - Requirements Template'
    team_deliverable true
    due_date Time.now + 10
    weight 5

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_4, :parent => :assignment do
    task_number 1
    title 'Briefing 1'
    team_deliverable false
    due_date Time.now + 10
    weight 4
  end

  factory :foundations_assignment_5, :parent => :assignment do
    task_number 2
    title 'Iteration 0'
    team_deliverable true
    due_date Time.now + 30
    weight 10

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_6, :parent => :assignment do
    task_number 2
    title 'Learning Rails'
    team_deliverable false
    due_date Time.now + 30
    weight 15
  end

  factory :foundations_assignment_7, :parent => :assignment do
    task_number 3
    title 'Iteration 1'
    team_deliverable true
    due_date Time.now + 40
    weight 10

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_8, :parent => :assignment do
    task_number 3
    title 'Peer Evaluations'
    team_deliverable false
    due_date Time.now + 40
    weight 4
  end

  factory :foundations_assignment_9, :parent => :assignment do
    task_number 4
    title 'Iteration 2'
    team_deliverable true
    due_date Time.now + 50
    weight 10

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_10, :parent => :assignment do
    task_number 4
    title 'Briefing 2'
    team_deliverable false
    due_date Time.now + 50
    weight 4
  end

  factory :foundations_assignment_11, :parent => :assignment do
    task_number 5
    title 'Iteration 3'
    team_deliverable true
    due_date Time.now + 60
    weight 10

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_12, :parent => :assignment do
    task_number 5
    title 'Iteration 3 - Final Presentation'
    team_deliverable true
    due_date Time.now + 60
    weight 10

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :foundations_assignment_13, :parent => :assignment do
    task_number 6
    title 'Retrospective'
    team_deliverable true
    due_date Time.now + 70
    weight 5

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end


  factory :foundations_current_semester, :parent => :course do
    name 'Foundations of Software Engineering'
    short_name 'FSE'
    number '96-700'
    grading_nomenclature 'Tasks'
    grading_criteria 'Points'
    faculty_assignments []

    after(:create) do |course|
      faculty_dwight = FactoryGirl.create(:faculty_dwight_user)
      course.faculty_assignments_override = [faculty_dwight.human_name]
      course.update_faculty

      course.teams << FactoryGirl.create(:course_team_1, course: course, name: '3 Amigos', email: '3Amigos@sv.cmu.edu')
      course.teams << FactoryGirl.create(:course_team_2, course: course, name: 'TeamCray', email: 'TeamCray@sv.cmu.edu')

      lonely_student = FactoryGirl.create(:student)
      FactoryGirl.create(:registration, user: lonely_student, course: course)
      course.registered_students << lonely_student

      course.assignments << FactoryGirl.create(:foundations_assignment_1, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_2, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_3, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_4, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_5, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_6, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_7, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_8, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_9, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_10, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_11, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_12, course: course)
      course.assignments << FactoryGirl.create(:foundations_assignment_13, course: course)
    end
  end
end