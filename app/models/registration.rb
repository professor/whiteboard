class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :person

  scope :for_course, lambda { |course_id|
    where(:course_id => course_id) unless course_id.nil?
  }

  def self.scoped_by_params( params={} )
    # Raise record not found and let controller handle
    # response if provided course_id is invalid
    course = Course.find_by_id!(params[:course_id]) if params[:course_id].present?

    self.for_course(params[:course_id])
  end

  def self.process_import( courses_data )
    result = {
      :success    => 0,
      :failed     => 0,
      :noop       => 0,
      :successes  => [],
      :failures   => [],
      :noops      => []
    }

    courses_data.each do |imported_course|
      course = Course.find_by_id(imported_course.number)

      if course.nil?
        result[:failed]   += imported_course.students.size
        result[:failures] << { imported_course.number => imported_course.students.map(&:user_id) }
      else
        imported_course.students.each do |imported_student|
          student     = Person.find_by_webiso_account(imported_student.user_id)
          result_hash = { imported_course.number => imported_student.user_id }

          if student.nil?
            result[:failed]   += 1
            result[:failures] << result_hash
          else
            if course.students.include?(student)
              result[:noop]   += 1
              result[:noops]  << result_hash
            else
              result[:success]    += 1
              result[:successes]  << result_hash
              course.students << student
            end
          end
        end
      end
    end

    result
  end
end
