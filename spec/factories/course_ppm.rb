require_relative "../lib/course_helper"

FactoryGirl.define do
  factory :ppm_assignment_1, :parent => :assignment do
    task_number 1
    title 'Process Briefing Team'
    team_deliverable true
    due_date DateTime.now + 10
    weight 12

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :ppm_assignment_2, :parent => :assignment do
    task_number 1
    title 'Process Briefing Individual'
    team_deliverable false
    due_date DateTime.now + 20
    weight 8

    after(:create) do |assignment|
      create_individual_deliverable(assignment, assignment.course.teams.first.members.first)
      create_individual_deliverable(assignment, assignment.course.teams.last.members.first)
    end
  end

  factory :ppm_assignment_3, :parent => :assignment do
    task_number 2
    title 'Software Engineering Plan'
    team_deliverable true
    due_date DateTime.now + 30
    weight 35

    after(:create) do |assignment|
      create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :ppm_assignment_4, :parent => :assignment do
    task_number 2
    title 'Presentation Team'
    team_deliverable true
    due_date DateTime.now + 40
    weight 3

    after(:create) do |assignment|
      #create_team_deliverable(assignment, assignment.course.teams.first)
      create_team_deliverable(assignment, assignment.course.teams.last)
    end
  end

  factory :ppm_assignment_5, :parent => :assignment do
    task_number 2
    title 'Presentation Individual'
    team_deliverable false
    due_date DateTime.now + 40
    weight 12

    after(:create) do |assignment|
      create_individual_deliverable(assignment, assignment.course.teams.first.members.first)
      create_individual_deliverable(assignment, assignment.course.teams.last.members.first)
    end
  end

  factory :ppm_assignment_6, :parent => :assignment do
    task_number 3
    title 'Reflection Briefing'
    team_deliverable false
    due_date DateTime.now + 40
    weight 10

    after(:create) do |assignment|
      create_individual_deliverable(assignment, assignment.course.teams.first.members.first)
      create_individual_deliverable(assignment, assignment.course.teams.last.members.first)
    end
  end

  factory :ppm_assignment_7, :parent => :assignment do
    task_number ''
    title 'Contribution'
    team_deliverable false
    due_date DateTime.now + 50  # Should be removed
    weight 20
    can_submit false
  end

  factory :ppm_current_semester, :parent => :course do
    name 'Process and Project Management'
    short_name 'PPM'
    number '96-782'
    grading_nomenclature 'Tasks'
    grading_criteria 'Percentage'
    faculty_assignments []

    after(:create) do |course|
      faculty_fagan = FactoryGirl.create(:faculty_fagan)
      course.faculty_assignments_override = [faculty_fagan.human_name]
      course.update_faculty

      course.teams << FactoryGirl.create(:course_team_1, course: course, name: '20 Amigos', email: '20Amigos@sv.cmu.edu')
      course.teams << FactoryGirl.create(:course_team_2, course: course, name: 'Team2Cool', email: 'Team2Cool@sv.cmu.edu')

      course.assignments << FactoryGirl.create(:ppm_assignment_1, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_2, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_3, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_4, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_5, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_6, course: course)
      course.assignments << FactoryGirl.create(:ppm_assignment_7, course: course)
    end
  end
end