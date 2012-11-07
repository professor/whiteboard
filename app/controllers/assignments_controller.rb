class AssignmentsController < ApplicationController
  load_and_authorize_resource

  layout 'cmu_sv'

  def course_assignments
    @assignments = Assignment.find_all_by_course_id(params[:course_id])
    @course = Course.find(params[:course_id])
  end

  def new_course_assignment
    @assignment = Course.find(params[:course_id]).assignments.build
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      @assignment.create_placeholder_deliverable(current_user)
      flash[:success] = "Assignment saved"
      redirect_to course_assignments_path(params[:assignment][:course_id])
    else
      flash[:error] = "Assignment could not be saved #{@assignment.inspect}"
      render 'new_course_assignment'
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      redirect_to course_assignments_path(@assignment[:course_id]), notice: "Assignment updated"
    else
      flash[:error] = "Assignment was not updated"
      render 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    course_id = @assignment[:course_id]
    if @assignment.deliverables.empty?
      flash[:success] = "Assignment was deleted"
      @assignment.destroy
    else
      flash[:error] = "Assignment cannot be deleted because it has deliverables"
    end
    redirect_to course_assignments_path(course_id)
  end
end
