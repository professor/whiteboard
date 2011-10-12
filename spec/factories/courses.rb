require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :fse, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'FSE'
end

Factory.define :mfse, :parent => :course do |c|
  c.name 'Metrics for Software Engineers'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.next_semester
  c.year AcademicCalendar.next_semester_year
end

Factory.define :mfse_current_semester, :parent => :course do |c|
  c.name 'Metrics for Software Engineers'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.cwyear
end