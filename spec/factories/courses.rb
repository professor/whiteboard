#require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :course, :class => Course do |c|
  c.name 'Course'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.year
  c.mini 'Both'
  c.number '96-700'
  c.updated_by_user_id 10
end

Factory.define :fse, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'FSE'
end

Factory.define :mfse, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.next_semester
  c.year AcademicCalendar.next_semester_year
end

Factory.define :mfse_current_semester, :parent => :course do |c|
  c.name 'Foundations of Software Engineering'
  c.short_name 'MfSE'
  c.semester AcademicCalendar.current_semester
  c.year Date.today.cwyear
end