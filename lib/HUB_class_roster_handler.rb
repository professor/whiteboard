module HUBClassRosterHandler
  def self.handle roster_text
    raise ArgumentError if roster_text.blank?
    roster_text = roster_text.gsub("\n", ' ').gsub("\r", ' ')
    parsed_courses = roster_text.split('CLASS ROSTER')

    unless parsed_courses.any?
      raise "Could not read your file, please check format."
    end

    courses = Course.all :include => [:users]
    users = User.all

    students_for_course = {}

    parsed_courses.each do |parsed_course|
      if /Run Date: (.*) Course: (.*) Sect:\s*(\w+).*Semester: (.*)College:(.*)Department:(.*)Instructor\(s\): (.*)Name.*?_+(.*)/.match(parsed_course)
        course_id = $2.strip
        student_webiso_accounts = $8.scan(/\d+\.\d.*?(\w+)/)

        course = courses.select { |c| c.number.gsub('-', '').to_s.eql?(course_id) }.first

        student_webiso_accounts.each do |webiso_account|
          student = users.select { |u| u.webiso_account == ("#{webiso_account[0]}@andrew.cmu.edu") }.first
          if student
            students_for_course[course] = Set.new unless students_for_course[course]
            students_for_course[course] << student
          end
        end
        Rails.logger.debug "Students_for_course::: #{students_for_course}"
      end
    end
    return self.handle_roster_changes students_for_course
  end

  def self.handle_roster_changes students_for_course
    roster_changes = {}
    changes = false
    students_for_course.each do |course, students|
      roster_changes[course] = {}
      roster_changes[course][:added] = students.to_a - course.users
      roster_changes[course][:dropped] = course.users - students.to_a
      Rails.logger.debug "Added: #{course.users - students.to_a}"


      course.users.delete_if { |s| roster_changes[course][:dropped].include? s }
      roster_changes[course][:added].each { |s| course.users << s }

      if roster_changes[course][:added].any? || roster_changes[course][:dropped].any?
        changes = true
      end
      course.save
    end
    self.send_emails roster_changes
    return changes
  end

  def self.send_emails roster_changes
    roster_changes.each do |course, info|
      options = {:to => course.faculty.collect(&:email), :subject => "Roster change for your course #{course.name}",
                 :message => self.roster_change_message(info[:added], info[:dropped])}
      GenericMailer.email(options).deliver
    end
  end

  def self.roster_change_message added, dropped
    message = ''
    if added.any?
      message += "#{added.count} students added to the course"
      added.each { |student| message += "#{student.first_name}  #{student.last_name}\n" }
    end

    if dropped.any?
      message += "#{dropped.count} students dropped from the course:"
      dropped.each { |student| message += "#{student.first_name}  #{student.last_name}\n" }
    end
    message
  end
end
