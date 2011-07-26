class CourseMailer < ActionMailer::Base

    def configure_course_faculty_email(course, options = {})
    subject    options[:subject] || "Please let us know about your course #{course.name} (#{course.semester} #{course.year})"
    recipients options[:to] || course.faculty.collect { |person| person.email }
    from       options[:from] || "CMU-SV Official Communication <help@sv.cmu.edu>"
    bcc        options[:cc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :course => course
  end

  def configure_course_admin_email(course, options = {})
    subject    options[:subject] || "Faculty has configured a course #{course.semester} #{course.year} #{course.name}"
    recipients options[:to] || "help@sv.cmu.edu"
    from       options[:from] || "CMU-SV Official Communication <help@sv.cmu.edu>"
    bcc        options[:cc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :course => course
  end

end


