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

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:success] = "Assignment was updated"
      redirect_to course_assignments_path(@assignment[:course_id])
    else
      flash[:error] = "Assignment was not updated"
      redirect_to 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    course_id = @assignment[:course_id]
    @assignment.destroy
    redirect_to course_assignments_path(course_id)
  end
end
