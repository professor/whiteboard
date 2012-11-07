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

  factory :architecture_assignment_1, :parent => :assignment do
    task_number 1
    title 'Compose and Evaluate an Architecture'
    team_deliverable false
    due_date DateTime.now + 10
    weight 20

    after(:create) do |assignment|
      team_1 = assignment.course.teams.first
      team_2 = assignment.course.teams.last
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_1.members.first, assignment: assignment)
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_2.members.first, assignment: assignment)
    end
  end

  factory :architecture_assignment_2, :parent => :assignment do
    task_number 2
    title 'Analyze and Architecture'
    team_deliverable true
    due_date DateTime.now + 20
    weight 20

    after(:create) do |assignment|
      team_1 = assignment.course.teams.first
      team_2 = assignment.course.teams.last
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_1.members.first, team: team_1, assignment: assignment)
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_2.members.first, team: team_2, assignment: assignment)
    end
  end

  factory :architecture_assignment_3, :parent => :assignment do
    task_number 3
    title 'Realize and Evaluate an Architecture'
    team_deliverable true
    due_date DateTime.now + 30
    weight 20

    after(:create) do |assignment|
      team_1 = assignment.course.teams.first
      team_2 = assignment.course.teams.last
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_1.members.first, team: team_1, assignment: assignment)
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_2.members.first, team: team_2, assignment: assignment)
    end
  end

  factory :architecture_assignment_4, :parent => :assignment do
    task_number 4
    title 'Write a Paper and a Technical Report'
    team_deliverable true
    due_date DateTime.now + 40
    weight 20

    after(:create) do |assignment|
      team_1 = assignment.course.teams.first
      team_2 = assignment.course.teams.last
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_1.members.first, team: team_1, assignment: assignment)
      assignment.deliverables << FactoryGirl.create(:deliverable, creator: team_2.members.first, team: team_2, assignment: assignment)
    end
  end

  factory :architecture_assignment_5, :parent => :assignment do
    task_number ''
    title 'Individual Participation'
    team_deliverable true
    due_date DateTime.now + 50  # Should be removed
    weight 20
    can_submit false
  end

  factory :architecture_team_1, :parent => :team do
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

  factory :architecture_team_2, :parent => :team do
    name "Best Team Never"
    email "TeamAwesome@sv.cmu.edu"
    tigris_space "http://TeamAwesome.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    updating_email false
    members []
    after(:create) do |team|
      10.times { team.members << FactoryGirl.create(:student)}
    end
  end

  factory :architecture_current_semester, :parent => :course do
    name 'Architecture and Design'
    short_name 'Architecture'
    number '96-750'
    grading_nomenclature 'Tasks'
    grading_criteria 'Points'
    faculty_assignments {[FactoryGirl.create(:faculty_assignment)]}

    after(:create) do |course|
      course.teams << FactoryGirl.create(:architecture_team_1, course: course)
      course.teams << FactoryGirl.create(:architecture_team_2, course: course)

      course.assignments << FactoryGirl.create(:architecture_assignment_1, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_2, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_3, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_4, course: course)
      course.assignments << FactoryGirl.create(:architecture_assignment_5, course: course)
    end
  end
end