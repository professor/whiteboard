class AssignmentsController < ApplicationController
  # GET /assignments
  # GET /assignments.xml
  before_filter :authenticate_user!
  before_filter :get_course
  before_filter :set_due_date, :only=>[:create, :update]
  load_and_authorize_resource



  layout 'cmu_sv'
  def get_course
    @course=Course.find(params[:course_id])
  end


  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.xml
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
  end

  def set_due_date
    params[:assignment][:due_date] = params[:due_date][:date] + " " + params[:due_date][:hour] + ":" + params[:due_date][:minute]
  end
  
  # POST /assignments
  # POST /assignments.xml
  def create
    @assignment = @course.assignments.new(params[:assignment])
    respond_to do |format|
      if @assignment.save
        format.html { redirect_to(course_assignments_path, :notice => "Assignment  #{@assignment.name} was successfully created.") }
        format.xml  { render :xml => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to(course_assignments_path, :notice => "Assignment #{@assignment.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(course_assignments_path) }
      format.xml  { head :ok }
    end
  end
end
