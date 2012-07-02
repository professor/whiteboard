FactoryGirl.define do

factory :fse, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'FSE'
end

factory :mfse, :parent => :course do |c|
  c.name 'Metrics for Software Engineers'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.next_semester
  c.year AcademicCalendar.next_semester_year
  c.number '96-700'
end

factory :mfse_fall_2011, :parent => :course do |c|
  c.name 'Metrics for Software Engineers'
  c.short_name 'MfSE'
  c.semester "Fall"
  c.year 2011
  c.number '96-703'
end

factory :fse_fall_2011, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'FSE'
  c.semester "Fall"
  c.year 2011
  c.number '96-700'
end


factory :mfse_current_semester, :parent => :course do |c|
  c.name 'Metrics for Software Engineers'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.cwyear
end

end