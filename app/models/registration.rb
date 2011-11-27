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
      course = Course.find_by_id(imported_course.number)

      # might be a parse error if this is not found
      if course.nil?
        result[:failures] += imported_course.students.size
        result[:failed]   << { imported_course.number => imported_course.students.map(&:user_id) }
      else
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
        current_course_roster = course.students

        imported_course.students.each do |imported_student|
          student = Person.find_by_webiso_account(imported_student.user_id)
          result_hash = { imported_course.number => imported_student.user_id }

          if student.present?
            if current_course_roster.include?(student)
              result[:noops]      += 1
              result[:noop]       << result_hash
              registered_students |= student
              current_course_roster.delete(student)
            else
              result[:adds]       += 1
              result[:added]      << result_hash
              registered_students |= [student]
            end
          else
            result[:failures]   += 1
            result[:failed]     << result_hash
          end
        end

        result[:drops] = current_course_roster.size
        current_course_roster.each do |student|
          result[:dropped] << { imported_course.number => student.webiso_account }
        end

        course.registered_students = registered_students
      end
    end

    result
  end
end
