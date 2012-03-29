module HUBClassRosterHandler
  def self.handle roster_text
    raise ArgumentError if roster_text.blank?
    roster_text = roster_text.gsub("\n", ' ').gsub("\r", ' ')
    parsed_courses = roster_text.split('CLASS ROSTER')

    unless parsed_courses.any?
      raise "Could not read your file, please check format."
    end

    courses = Course.all :include => [:registered_students]
    users = User.all

    students_for_course = {}

    parsed_courses.each do |parsed_course|
      if /Run Date: (.*) Course: (.*) Sect:\s*(\w+).*Semester: (.*)College:(.*)Department:(.*)Instructor\(s\): (.*)Name.*?_+(.*)/.match(parsed_course)
        course_number = $2.strip
        student_webiso_accounts = $8.scan(/\d+\.\d.*?(\w+)/)

        course = courses.select { |c| c.number.gsub('-', '').to_s == (course_number) }.first
        next unless course
        students_for_course[course] = students_for_course[course] || Set.new

        student_webiso_accounts.each do |webiso_account|
          student = users.select { |u| u.webiso_account == ("#{webiso_account[0]}@andrew.cmu.edu") }.first
          #next
          unless student
#            UserMailer.email_help_about_missing_student(webiso_account, course)
            self.email_help_about_missing_student(webiso_account[0], course)
            next
          end
          students_for_course[course] << student
        end
      end
    end
    Rails.logger.debug "Students_for_course::: #{students_for_course}"
    return self.handle_roster_changes students_for_course
  end

  def self.handle_roster_changes students_for_course
    roster_changes = {}
    changes = false
    students_for_course.each do |course, students|
      roster_changes[course] = {}
      roster_changes[course][:added] = students.to_a - course.registered_students
      roster_changes[course][:dropped] = course.registered_students - students.to_a
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
                 :message => "We were adding registered HUB users to the course #{course.name}, but they aren''t in the system.",
                 :url => "http://rails.sv.cmu.edu/people/new?webiso_account=#{webiso_account}@andrew.cmu.edu&is_student=true",
                 :url_label => "Add person"}
      GenericMailer.email(options).deliver
  end


  def self.send_emails roster_changes
    roster_changes.each do |course, info|
      next if info[:added].blank? && info[:dropped].blank?
      email_professors_about_added_and_dropped_students(course, info)
    end
  end

  def self.email_professors_about_added_and_dropped_students course, info
    options = {:to => course.faculty.collect(&:email), :subject => "Roster change for your course #{course.name}",
               :message => self.roster_change_message(info[:added], info[:dropped])}
    GenericMailer.email(options).deliver
  end

  def self.roster_change_message added, dropped
    message = ''
    if added.any?
      message += "#{added.count} students added to the course:\n"
      added.each { |student| message += "\t#{student.first_name}  #{student.last_name}\n" }
    end

    if dropped.any?
      message += "#{dropped.count} students dropped from the course:\n"
      dropped.each { |student| message += "\t#{student.first_name}  #{student.last_name}\n" }
    end
    message
  end
end
