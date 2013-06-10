FactoryGirl.define do

  factory :fse, :parent => :course do
    name 'Foundations of Software Engineering'
    short_name 'FSE'
  end

  factory :ise, :parent => :course do
    name 'Introduction to Software Engineering'
    short_name 'ISE'
  end

  factory :course_fse_with_students, :parent => :fse do  |c|
    registered_students { |registered_students| [registered_students.association(:team_member)] }
    c.after(:build) {|c| c.registered_students.each  { |s|  FactoryGirl.build(:registration, :course_id=>c.id, :user_id => s.id) } }
  end

  factory :course_ise_with_students, :parent => :ise do  |c|
    registered_students { |registered_students| [registered_students.association(:team_member)] }
    c.after(:build) {|c| c.registered_students.each  { |s|  FactoryGirl.build(:registration, :course_id=>c.id, :user_id => s.id) } }
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

end