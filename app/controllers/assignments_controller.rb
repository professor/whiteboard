class AssignmentsController < ApplicationController
  layout 'cmu_sv'

  def course_assignments
    @assignments = Assignment.find_all_by_course_id(params[:id])
    @course = Course.find(params[:id])
  end

  def new_course_assignment
    @assignment = Course.find(params[:id]).assignments.build
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      flash[:success] = "Assignment saved"
      redirect_to course_assignments_path(params[:assignment][:course_id])
    else
      flash[:error] = "Assignment could not be saved"
      redirect_to course_assignments_path(params[:assignment][:course_id])
    end
  end
end
