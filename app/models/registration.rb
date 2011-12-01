class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :person

  scope :for_course, lambda { |course_id|
    where(:course_id => course_id) unless course_id.nil?
  }

  def self.scoped_by_params( params={} )
    self.for_course(params[:course_id])
  end

  def self.process_import( courses_data )
    result = {
      :adds       => 0,
      :failures   => 0,
      :noops      => 0,
      :drops      => 0,
      :added      => [],
      :failed     => [],
      :noop       => [],
      :dropped    => []
    }

    courses_data.each do |imported_course|
      course = Course.find_by_number(imported_course.number.to_s)
      #the following three lines are variables used for the RegistrationMailer notifications
      instructors_email_list = Array.new()
      
      # might be a parse error if this is not found
      if course.nil?
        result[:failures] += imported_course.students.size
        imported_course.students.each do |student|
          result[:failed] << { imported_course.number => student.user_id }
        end
      else
        #get the faculty's email distribution list
        last_names = imported_course.instructors.map{|k| k.slice(/\w+/)}
        last_names.each do |last_name|
          faculty = User.find_by_last_name(last_name.capitalize)
          instructors_email_list  << faculty.email
        end
        
        # The logic here might be a little complicated
        # Basically, we want to iterate over each of the imported
        # registrations and check if they are already set in the DB.
        # The hardest part was keeping track of dropped students since
        # we do not want to do a table scan of person table. The strategy
        # is to load the current roster and mark them off as we iterate over
        # the imports. The leftover students in the array represent drops.
        # To handle the actual removal of registration, we simply override the
        # course.registered_students array and old ones will be destroyed per
        # ActiveRecord magic.
        registered_students = []
        current_course_roster = course.students.clone
    
        #loop through students
        imported_course.students.each do |imported_student|
          student = Person.find_by_login(imported_student.user_id)
          result_hash = { imported_course.number => imported_student.user_id }

          if student.present?
            if current_course_roster.include?(student)
              result[:noops]      += 1
              result[:noop]       << result_hash
              registered_students |= [student]
              current_course_roster.delete(student)
            else
              result[:adds]       += 1
              result[:added]      << student
              registered_students |= [student]
            end
          else
            result[:failures]   += 1
            result[:failed]     << result_hash
          end
        end

        result[:drops] = current_course_roster.size
        current_course_roster.each do |student|
          result[:dropped] << student
        end

        course.students = registered_students
      end

      logger.info "course: #{course.inspect}"
    
      #send the email notifications for added and dropped students
      unless instructors_email_list.present?
        unless result[:added].present?
            RegistrationMailer.notify_faculty_of_added_students(instructors_email_list,result[:added],course).deliver
        end
        
        unless result[:dropped].present?
          RegistrationMailer.notify_faculty_of_dropped_students(instructors_email_list,result[:dropped],course).deliver
        end
      end
    end

    result
  end
end
