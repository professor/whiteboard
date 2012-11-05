class CourseUserGradesController < ApplicationController
  def create
    @course = Course.find_by_id(params[:course_user_grade][:course_id])
    course_user_grade = CourseUserGrade.create(params[:course_user_grade])
    if course_user_grade.save
      flash[:success] = 'Grade save successful'
      redirect_to course_gradebook_path(self.course.id)
    else
      flash[:error] = 'Unable to save grades'
      render 'courses/gradebook'
    end
  end
end