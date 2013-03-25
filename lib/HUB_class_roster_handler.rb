module HUBClassRosterHandler
  extend ActionView::Helpers::TextHelper

  def self.handle roster_text
    raise ArgumentError if roster_text.blank?
    roster_text = roster_text.gsub("\n", ' ').gsub("\r", ' ')
    parsed_courses = roster_text.split('CLASS ROSTER')

    unless parsed_courses.any?
      raise "Could not read your file, please check format."
    end

    users = User.all

    students_for_course = {}
    students_not_in_system_hash = {}
    no_courses_parsed = true

    parsed_courses.each do |parsed_course|
      if /Run Date: (.*) Course: (.*) Sect:\s*(\w+).*Semester: (.*)College:(.*)Department:(.*)Instructor\(s\): (.*)Name.*?_+(.*)/.match(parsed_course)
        no_courses_parsed = false
        course_number = $2.strip
        (semester, year) = AcademicCalendar.parse_HUB_semester($4.strip)

        student_webiso_accounts = $8.scan(/\d+\.\d.*?(\w+)/)

        course = Course.where(:semester => semester, :year => year, :number => course_number[0..1] + '-' + course_number[2..4]).first :include => [:registered_students]
        next unless course
        students_for_course[course] = students_for_course[course] || Set.new
        students_not_in_system_hash[course] = students_not_in_system_hash[course] || Set.new

        student_webiso_accounts.each do |webiso_account|
          student = users.select { |u| u.webiso_account == ("#{webiso_account[0]}@andrew.cmu.edu") }.first
          #next
          unless student
            self.email_help_about_missing_student(webiso_account[0], course)
            students_not_in_system_hash[course] << webiso_account[0]
            next
          end
          students_for_course[course] << student
        end
      end
    end

    if no_courses_parsed
      raise "Could not read your file, please check format."
    end

    Rails.logger.debug "Students_for_course::: #{students_for_course}"
    return self.handle_roster_changes students_for_course, students_not_in_system_hash
#    return self.handle_roster_changes students_for_course
  end

  def self.handle_roster_changes students_for_course, students_not_in_system_hash
#  def self.handle_roster_changes students_for_course
    roster_changes = {}
    changes = false
    students_for_course.each do |course, students|
      roster_changes[course] = {}
      roster_changes[course][:added] = students.to_a - course.registered_students
      roster_changes[course][:dropped] = course.registered_students - students.to_a
      roster_changes[course][:not_in_system] = students_not_in_system_hash[course]

      Rails.logger.debug "Added: #{roster_changes[course][:added]}"
      Rails.logger.debug "Dropped: #{roster_changes[course][:dropped]}"

      course.registered_students = course.registered_students - roster_changes[course][:dropped]
      course.registered_students = course.registered_students + roster_changes[course][:added]

      if roster_changes[course][:added].any? || roster_changes[course][:dropped].any?
        course.invalidate_distribution_list
        changes = true
      end
      course.save
    end
    Rails.logger.debug roster_changes
    self.send_emails roster_changes
    return changes
  end

  def self.email_help_about_missing_student webiso_account, course
    options = {:to => "todd.sedano@sv.cmu.edu", :subject => "Need to add this user #{webiso_account}@andrew.cmu.edu",
               :message => "We were adding registered HUB users to the course #{course.name}, but they are not in the system.",
               :url => "http://whiteboard.sv.cmu.edu/people/new?webiso_account=#{webiso_account}@andrew.cmu.edu&is_student=true",
               :url_label => "Add person"}
    GenericMailer.email(options).deliver
  end


  def self.send_emails roster_changes
    roster_changes.each do |course, info|
      next if info[:added].blank? && info[:dropped].blank? && info[:not_in_system].blank?
      email_professors_about_added_and_dropped_students(course, info)
    end
  end

  def self.email_professors_about_added_and_dropped_students course, info
    faculty_emails = course.faculty.collect(&:email)
    if faculty_emails.any?
      options = {:to => faculty_emails, :subject => "Roster change for your course #{course.name}",
                 :message => self.roster_change_message(course, info[:added], info[:dropped], info[:not_in_system])}
# The message handles this well...
#                 :url_label => "Your course: " + course.number + " " + course.short_or_full_name,
#                 :url => "http://whiteboard.sv.cmu.edu/courses/#{course.id}" }
    else
      options = {:to => "gerry.elizondo@sv.cmu.edu", :subject => "Please add faculty to this course",
                 :message => "The HUB importer code was just run, however this course has no faculty assigned to it. Thus, I could not email them.",
                 :url_label => "The course: " + course.number + " " + course.short_or_full_name,
                 :url => "http://whiteboard.sv.cmu.edu/courses/#{course.id}" }
    end

    GenericMailer.email(options).deliver
  end

  def self.roster_change_message course, added, dropped, not_in_system

    unless course
      message = "This email is supposed to contain information about course roster changes, but an error occurred while"
      message += "generating its contents.  Please contact <a href='mailto:todd.sedano@sv.cmu.edu?subject=Roster%20Email%20Error'>Todd Sedano</a>"
      return message += "to resolve any issues."
    end

    message = "** This is an experimental feature. ** "
    message += "The official registration list for your course can be <a href='https://acis.as.cmu.edu/grades/'>found here</a>.<br/><br/>"
    message += "By loading in HUB data we can auto create class email distribution lists. Also, if you create teams with the rails system, then you can see who has not been assigned to a team. This does not currently track students on wait-lists. We only have access to students registered in 96-xxx courses.<br/><br/>"
    message += "The HUB does not provide us with registration information on a daily basis. Periodically, we manually upload HUB registrations. This is a summary of changes since the last time we updated information from the HUB.<br/><br/>"

    unless not_in_system.blank?
      message += "#{pluralize(not_in_system.count, "registered student")} #{not_in_system.count > 1 ? "are" : "is"} not in any of our SV systems:<br/>"
      not_in_system.each { |student|
        escaped_student = ERB::Util.html_escape(student)
        message += "&nbsp;&nbsp;&nbsp;#{escaped_student}@andrew.cmu.edu<br/>"
      }
      message += "We can easily create accounts for #{not_in_system.count > 1 ? "these" : "this"} #{pluralize(not_in_system.count, "student")}. Please forward this email to help@sv.cmu.edu indicating which students you want added. (The rails system will create google and twiki accounts.)<br/><br/>"
    end

    unless added.blank?
      message += "#{pluralize(added.count, "student")} #{added.count > 1 ? "were" : "was"} added to the course:<br/>"
      added.each { |student|
        escaped_first_name = ERB::Util.html_escape(student.first_name)
        escaped_last_name = ERB::Util.html_escape(student.last_name)
        message += "&nbsp;&nbsp;&nbsp;#{escaped_first_name} #{escaped_last_name}<br/>"
      }
    end

    unless dropped.blank?
      message += "#{pluralize(dropped.count, "student")} #{dropped.count > 1 ? "were" : "was"} dropped from the course:<br/>"
      dropped.each { |student|
        escaped_first_name = ERB::Util.html_escape(student.first_name)
        escaped_last_name = ERB::Util.html_escape(student.last_name)
        message += "&nbsp;&nbsp;&nbsp;#{escaped_first_name} #{escaped_last_name}<br/>"
      }
    end

    escaped_course_email = ERB::Util.html_escape(course.email)
    message += "<br/>The system will be updating your course mailing list (#{escaped_course_email}) For more information, see your <a href='http://whiteboard.sv.cmu.edu/courses/#{course.id}'>course tools</a><br/><br/>"

    message
  end
end
