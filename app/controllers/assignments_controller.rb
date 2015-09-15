class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.xml
  before_filter :authenticate_user!
  before_filter :get_course
  before_filter :render_grade_book_menu

  layout 'cmu_sv'

  def get_course
    @course=Course.find(params[:course_id])
    @wording = @course.nomenclature_assignment_or_deliverable
  end

  def render_grade_book_menu
    @is_in_grade_book = true
  end

  def index
    @assignments = Assignment.all(:conditions => ["course_id = ?", @course.id])
    authorize! :read, Assignment

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @assignments }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new
    authorize! :update, @course

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
    authorize! :update, @course
  end

  # POST /assignments
  # POST /assignments.xml
  def create
    @assignment = @course.assignments.new(params[:assignment])
    authorize! :update, @course
    @assignment.set_due_date(params[:due_date][:date], params[:due_date][:hour], params[:due_date][:minute]) if params.has_key?(:due_date)
    respond_to do |format|
      if @assignment.save
        format.html { redirect_to(course_assignments_path, :notice => "#{@wording}  #{@assignment.name} was successfully created.") }
        format.xml { render :xml => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])
    authorize! :update, @course

    @assignment.set_due_date(params[:due_date][:date], params[:due_date][:hour], params[:due_date][:minute]) if params.has_key?(:due_date)
    deliverable_submitted=Deliverable.find_all_by_assignment_id(@assignment.id).first
    deliverable_status=0;
    unless deliverable_submitted.nil?
      if @assignment.is_team_deliverable.to_s!= params[:assignment]["is_team_deliverable"]
        deliverable_status=1
        flash[:error] = "You cannot change the Type as the student(s) has already submitted for this item."

      end
    end

    if deliverable_status==0
      respond_to do |format|
        if @assignment.update_attributes(params[:assignment])
          format.html { redirect_to(course_assignments_path, :notice => "Assignment #{@assignment.name} was successfully updated.") }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @assignment.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end


  end

  # DELETE /assignments/1
  # DELETE /assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    authorize! :destroy, @assignment

    @assignment.destroy
    respond_to do |format|
      format.js
    end
  end


  # GET /course/assignment_reorder/1
  def show
    @no_pad = true
    @assignments = @course.assignments
    authorize! :reorder_assignments, @course

    respond_to do |format|
      format.html # showml.erb
    end
  end

  #Inspiration for this technique comes from two sources
  # A: http://awesomeful.net/posts/47-sortable-lists-with-jquery-in-rails (yield javascript, jquery ui code)
  # B: http://henrik.nyh.se/2008/11/rails-jquery-sortables#comment-17220662 (model update code)

  def reposition
    authorize! :reorder_assignments, @course

    order = params[:assignment]
    Rails.logger.debug(order)
    Assignment.reposition(order)
    render :text => order.inspect
  end


end
