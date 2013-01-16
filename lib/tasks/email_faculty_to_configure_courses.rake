require 'rubygems'
require 'rake'

namespace :whiteboard do
  desc "Email faculty to configure their current semester course. "
  task(:email_faculty_to_configure_current_semester_courses => :environment) do

    count = 0
    Course.current_semester_courses.each do |course|
      response = course.email_faculty_to_configure_course_unless_already_configured
      count += 1 if response
    end

    puts "A total of #{count} courses were not configured"
  end

  desc "Email faculty to configure their next semester course. "
  task(:email_faculty_to_configure_next_semester_courses => :environment) do

    count = 0
    Course.next_semester_courses.each do |course|
      response = course.email_faculty_to_configure_course_unless_already_configured
      count += 1 if response
    end

    puts "A total of #{count} courses were not configured"
  end
end