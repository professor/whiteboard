class CourseUserGradesController < ApplicationController

  def create
    @course = Course.find_by_id(params[:course_user_grade][:course_id])
    course_user_grade = @course.course_user_grades.find_by_user_id(params[:course_user_grade][:user_id])
    if course_user_grade.blank?
      course_user_grade = CourseUserGrade.create(params[:course_user_grade])
    else
      course_user_grade.update_attributes(params[:course_user_grade])
    end
    if course_user_grade.save
      flash[:notice] = 'Grade save successful'
    else
      flash[:error] = 'Unable to save grades'
    end
    redirect_to course_gradebook_path(@course)
  end
end