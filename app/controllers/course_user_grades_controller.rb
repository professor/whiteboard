class CourseUserGradesController < ApplicationController

  def create
    @course = Course.find_by_id(params[:course_user_grade][:course_id])

    @message = nil
    if @course.faculty.include?(current_user)
      @course_user_grade = @course.course_user_grades.find_by_user_id(params[:course_user_grade][:user_id])

      if @course_user_grade.blank?
        @course_user_grade = CourseUserGrade.new(params[:course_user_grade])
        @success = @course_user_grade.save
      else
        @success = @course_user_grade.update_attributes(params[:course_user_grade])
      end
    else
      @message = "User must be a faculty teaching the course to assign grades"
      @success = false
    end

    respond_to do |format|
      format.js
    end
  end

  def notify_final_grade
    course = Course.find(params[:course_user_grade][:course_id])
    @student = User.find(params[:course_user_grade][:user_id])
    CourseUserGrade.notify_final_grade(course, @student)

    respond_to do |format|
      format.js
    end
  end

  def notify_final_grade_all
    course = Course.find(params[:course_user_grade][:course_id])
    @students = course.all_students.values

    @students.each do |student|
      CourseUserGrade.notify_final_grade(course, student)
    end

    respond_to do |format|
      format.js
    end
  end
end