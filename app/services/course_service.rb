class CourseService
    include ActiveModel::ForbiddenAttributesProtection

    def self.display_course_name(course)

        mini_text = course.mini == "Both" ? "" : course.mini
        result = self.short_or_full_name + course.semester + mini_text + course.year.to_s
        result.gsub(" ", "")
    end

    def self.display_for_course_page(course)
        # Consider this
        #    "#{self.number} #{self.name} (#{self.short_name}) #{self.display_semester}"
        "#{course.number} #{course.name} (#{course.short_name})"
    end
    #Todo
    #def self.display_name(course_id)

    #	course = Course.find_by_id(course_id.to_s.to_i)
    #  return course.name if course.short_name.blank?
    #  return course.name + " (" + course.short_name + ")"
    #end

    def self.short_or_full_name(course)

        unless course.short_name.blank?
            course.short_name
        else
            course.name
        end
    end

    #This is not used anywhere
    #		def short_or_course_number
    #		unless self.short_name.blank?
    #		  self.short_name
    #    else
    #      self.number
    #    end
    #  end

    def self.display_semester(course)
        mini_text = course.mini == "Both" ? "" : course.mini + " "
        return course.semester + " " + mini_text + course.year.to_s
    end

    def self.course_length(course)
        if course.mini == "Both" then
            if course.semester == "Summer" then
                return 12
            elsif course.semester == "Fall" then
                return 15
            else
                return 16
            end
        else
            if course.semester == "Summer" then
                return 6
            else
                return 7
            end
        end
    end


    def self.course_start(course)
        start = AcademicCalendar.semester_start(course.semester, course.year)

        if course.semester == "Spring" then
            return course.mini == "B" ? start + 9 : start
        end
        if course.semester == "Summer" then
            return course.mini == "B" ? start + 6 : start
        end
        if course.semester == "Fall" then
            return course.mini == "B" ? start + 8 : start
        end
        return 0 #If the semester field isn't set
    end

    def self.course_end(course)
        self.course_start(course) + self.course_length(course) - 1
    end

    def self.auto_generated_twiki_url(course)
        return "http://info.sv.cmu.edu/do/view/#{course.semester}#{course.year}/#{self.short_or_full_name(course)}/WebHome".delete(' ')
    end

    def self.auto_generated_peer_evaluation_date_start(course)
        return Date.commercial(course.year, self.course_start(course) + 6)
    end


    def self.auto_generated_peer_evaluation_date_end(course)
        return Date.commercial(course.year, self.course_start(course) + 7)
    end


    #def update_faculty(course)
    #    return "" if Course.faculty_assignments_override.nil?
    #    course.faculty = []

    #    Course.faculty_assignments_override = Course.faculty_assignments_override.select { |name| name != nil && #name.strip != "" }
    #    list = map_member_strings_to_users(Course.faculty_assignments_override)
    #    raise "Error converting faculty_assignments_override to IDs!" if list.include?(nil)
    #    course.faculty = list
    #    Course.faculty_assignments_override = nil
    #    course.updating_email = true
    #  end


    #  def copy_as_new_course
    #    new_course = self.clone
    #    new_course.is_configured = false
    #    new_course.configured_by = nil
    #   new_course.updated_by = nil
    #    new_course.created_at = Time.now
    #    new_course.updated_at = Time.now
    #    new_course.curriculum_url = nil if self.curriculum_url.nil? || self.curriculum_url.include?("twiki")
    #    new_course.faculty = self.faculty
    #    new_course.grading_rule = self.grading_rule.clone if self.grading_rule.present?
    #    self.assignments.each { |assignment| new_course.assignments << assignment.clone } if #self.assignments.present?
    #    return new_course
    #  end

    #Not being used anywhere. Yet to be implemented.  
    #  def copy_teams_to_another_course(destination_course_id)
    #Todo: at some point, refactor teams to be an ordered list, so that we wouldn't need to reverse it here #to preserve ordering.
    #   self.teams.reverse.each do |team|
    #     team.clone_to_another_course(destination_course_id)
    #   end
    # end

    #Dint find usage 
    #   def current_mini?
    #   case self.mini
    #     when "Both"
    #       self.year == Date.today.year && self.semester == AcademicCalendar.current_semester()
    #     else
    #       self.year == Date.today.year && self.mini == AcademicCalendar.current_mini()
    #   end
    #end


    def self.nomenclature_assignment_or_deliverable(course)
        if course.grading_rule.nil? || course.grading_rule.is_nomenclature_deliverable?
            "deliverable"
        else
            "assignment"
        end
    end


    def self.grade_type_points_or_weights(course)
        if course.grading_rule.nil? || course.grading_rule.grade_type=="points"
            "points"
        else
            "weights"
        end
    end



    #  def registered_students_or_on_teams
    #    self.registered_students | self.teams.collect { |team| team.members }.flatten
    #  end



    #protected

    #def strip_whitespaces
    #    @attributes.each do |attr, value|
    #      self[attr] = value.strip if value.is_a?(String)
    #    end
    #  end


    #  def build_email
    #    unless self.short_name.blank?
    #      email = "#{self.semester}-#{self.year}-#{self.short_name}".chomp.downcase.gsub(/ /, '-') + "@" + #GOOGLE_DOMAIN
    #    else
    #      email = "#{self.semester}-#{self.year}-#{self.number}".chomp.downcase.gsub(/ /, '-') + "@" + #GOOGLE_DOMAIN
    #    end
    #    email = email.gsub('&', 'and')
    #    email.sub('@west.cmu.edu', '@sv.cmu.edu')
    #  end



    #  def need_to_update_google_list?
    #    if self.email_changed?
    #      self.updating_email = true
    #    end
    #  end


    #    def update_distribution_list
    #    if self.updating_email
    #      recipients = self.faculty | self.registered_students_or_on_teams
    #      Delayed::Job.enqueue(GoogleMailingListJob.new(self.email, self.email, recipients, self.email, "Course #distribution list", self.id, "courses"))
    #    end
    #  end


    #  def copy_pages_to_another_course(destination_course_id, url_prefix)
    #    self.pages.each do |page|
    #      new = page.clone
    #      new.course_id = destination_course_id
    #      new.url = url_prefix + page.url
    #      new.save
    #    end
    #  end
end

