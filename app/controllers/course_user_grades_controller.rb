class CourseUserGradesController < ApplicationController

  def create
    @course = Course.find_by_id(params[:course_user_grade][:course_id])
    @course_user_grade = @course.course_user_grades.find_by_user_id(params[:course_user_grade][:user_id])

    if @course_user_grade.blank?
      @course_user_grade = CourseUserGrade.create(params[:course_user_grade])
    else
      @course_user_grade.update_attributes(params[:course_user_grade])
    end

    @success = @course_user_grade.save

    respond_to do |format|
      format.js
    end
  end
end