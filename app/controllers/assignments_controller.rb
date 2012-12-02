class AssignmentsController < ApplicationController
  before_filter :check_teaching_course

  layout 'cmu_sv'

  def course_assignments
    store_location
    @assignments = Assignment.find_all_by_course_id(params[:course_id])
    @course = Course.find(params[:course_id])
  end

  def new_course_assignment
    @assignment = Course.find(params[:course_id]).assignments.build
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      flash[:success] = "Assignment saved"
      redirect_to course_assignments_path(params[:assignment][:course_id])
    else
      flash[:error] = "Assignment could not be saved"
      render 'new_course_assignment'
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      redirect_back_or_default(course_assignments_path(@assignment.course))
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

  private

  def check_teaching_course
    if !params[:course_id].blank?
      course = Course.find(params[:course_id])
    elsif !params[:assignment].blank? && !params[:assignment][:course_id].blank?
      course = Course.find(params[:assignment][:course_id])
    elsif !params[:id].blank?
      course = Assignment.find(params[:id]).course
    end

    if course.blank? || (!can? :instruct, course)
      redirect_to root_path, flash: { error: "You must be teaching this course to access this page." }
    end
  end
end
