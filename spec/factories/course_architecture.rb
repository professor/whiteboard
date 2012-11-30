require_relative "../lib/course_helper"

FactoryGirl.define do
  factory :architecture_assignment_1, :parent => :assignment do
    task_number 1
    title 'Compose and Evaluate an Architecture'
    team_deliverable false
    due_date DateTime.now + 10
    weight 20

    after(:create) do |assignment|
      create_individual_deliverable(assignment, assignment.course.teams.first.members.first)
      create_individual_deliverable(assignment, assignment.course.teams.last.members.first)
    end
  end

  factory :architecture_assignment_2, :parent => :assignment do
    task_number 2
    title 'Analyze and Architecture'
    team_deliverable true
    due_date DateTime.now + 20
    weight 20

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :architecture_assignment_3, :parent => :assignment do
    task_number 3
    title 'Realize and Evaluate an Architecture'
    team_deliverable true
    due_date DateTime.now + 30
    weight 20

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :architecture_assignment_4, :parent => :assignment do
    task_number 4
    title 'Write a Paper and a Technical Report'
    team_deliverable true
    due_date DateTime.now + 40
    weight 20

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      #create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :architecture_assignment_5, :parent => :assignment do
    task_number ''
    title 'Individual Participation'
    team_deliverable false
    due_date DateTime.now + 50  # Should be removed
    weight 20
    can_submit false
  end

  factory :architecture_current_semester, :parent => :course do
    name 'Architecture and Design'
    short_name 'Architecture'
    number '96-705'
    grading_nomenclature 'Tasks'
    grading_criteria 'Points'
    faculty_assignments []

    after(:create) do |course|
      faculty_frank = FactoryGirl.create(:faculty_frank)
      course.faculty_assignments_override = [faculty_frank.human_name]
      course.update_faculty

      course.teams << FactoryGirl.create(:course_team_1, course: course, name: '10 Amigos', email: '10Amigos@sv.cmu.edu')
      course.teams << FactoryGirl.create(:course_team_2, course: course, name: 'Best Team Never', email: 'BestTeamNever@sv.cmu.edu')

      course.assignments << FactoryGirl.create(:architecture_assignment_1, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_2, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_3, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_4, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_5, course: course)
    end
  end
end