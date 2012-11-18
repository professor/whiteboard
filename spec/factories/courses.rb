def create_individual_deliverable(assignment, creator)
  deliverable = FactoryGirl.create(:deliverable, creator: creator, assignment: assignment)
  deliverable.attachment_versions << FactoryGirl.create(:deliverable_attachment, deliverable: deliverable, submitter: creator, attachment_file_name: "attachment")
  assignment.deliverables << deliverable
end

def create_team_deliverable(assignment, team)
  deliverable = FactoryGirl.create(:deliverable, creator: team.members.first, team: team, assignment: assignment)
  deliverable.attachment_versions << FactoryGirl.create(:deliverable_attachment, deliverable: deliverable, submitter: team.members.first, attachment_file_name: "attachment")
  assignment.deliverables << deliverable
end

FactoryGirl.define do

  factory :fse, :parent => :course do
    name 'Foundations of Software Engineering'
    short_name 'FSE'
  end

  factory :mfse, :parent => :course do
    name 'Metrics for Software Engineers'
    short_name 'MfSE'
    semester AcademicCalendar.next_semester
    year AcademicCalendar.next_semester_year
    number '96-700'
  end

  factory :mfse_fall_2011, :parent => :course do
    name 'Metrics for Software Engineers'
    short_name 'MfSE'
    semester "Fall"
    year 2011
    number '96-703'
  end

  factory :fse_fall_2011, :parent => :course do
    name 'Foundations of Software Engineering'
    short_name 'FSE'
    semester "Fall"
    year 2011
    number '96-700'
  end


  factory :mfse_current_semester, :parent => :mfse do
    semester AcademicCalendar.current_semester
    year Date.today.cwyear
  end

  factory :fse_current_semester, :parent => :fse do
    semester AcademicCalendar.current_semester
    year Date.today.cwyear
  end

  factory :course_team_1, :parent => :team do
    name "10 Amigos"
    email "10Amigos@sv.cmu.edu"
    tigris_space "http://10Amigos.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    updating_email false
    members []
    after(:create) do |team|
      10.times { team.members << FactoryGirl.create(:student)}
    end
  end

  factory :course_team_2, :parent => :team do
    name "Best Team Never"
    email "BestTeamNever@sv.cmu.edu"
    tigris_space "http://BestTeamNever.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    updating_email false
    members []
    after(:create) do |team|
      10.times { team.members << FactoryGirl.create(:student)}
    end
  end

  #
  # Architecture Course
  #

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

  #
  # PPM Course
  #

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