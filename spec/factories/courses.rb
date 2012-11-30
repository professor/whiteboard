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
end