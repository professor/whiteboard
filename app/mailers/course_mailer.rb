class CourseMailer < ActionMailer::Base
  default :from => "CMU-SV Official Communication <help@sv.cmu.edu>",
          :bcc => "todd.sedano@sv.cmu.edu"

  def configure_course_faculty_email(course, options = {})
    @course = course

    mail(:to => options[:to] || course.faculty.collect { |user| user.email },
         :subject => options[:subject] || "Please let us know about your course #{course.name} (#{course.semester} #{course.year})",
         :date => Time.now)
  end

  def configure_course_admin_email(course, options = {})
    @course = course

    mail(:to => options[:to] || "help@sv.cmu.edu",
         :subject => "Faculty has configured a course #{course.semester} #{course.year} #{course.name}",
         :date => Time.now)
  end

  def notify_final_grade(course, student)
    @student = student

    mail(:to => student.email,
         :subject => "Final grade for #{course.semester} #{course.year} #{course.name} was updated",
         :date => Time.now)
  end

end



