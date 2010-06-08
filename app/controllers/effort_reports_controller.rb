require 'google_chart'

class EffortReportsController < ApplicationController

#  layout "effort_logs", :except => "load_weekly_chart"


  before_filter :login_required

#    helper Ziya::Helper

    def index
    end
    
    def show_week
      @week_number = params[:week].to_i
      @next_week_number = @week_number + 1
      @prev_week_number = @week_number - 1
    end

    def show
      if params[:week] then 
        @week_number = params[:week].to_i
      else
        @week_number = (Date.today.cweek - 0) 
      end
      @next_week_number = @week_number + 1
      @this_week_number = @week_number
      @prev_week_number = @week_number - 1
    end

  
    def load_google_chart
      puts "test google place !!!!!!!!!!!!!!!!!!!!!!!!!!"
      GoogleChart::BoxChart.new('800x200', "Box Chart") do |bc|
#      GoogleChart::FinancialLineChart.new('800x200', "Box Chart") do |bc|
        bc.data "course1", [-1,5,10,7,12,-1]
        bc.data "course2", [-1,25,30,27,24,-1]
        bc.data "course3", [-1,40,45,47,39,-1]
        bc.data "course4", [-1,55,63,59,80,-1]
        bc.data "course5", [-1,30,40,35,30,-1]
        bc.data "course6", [-1,-1,5,70,90,-1]
        @chart = bc.to_url
     end
    end

    
    def load_weekly_chart
      if params[:week] then 
        @week_number = params[:week].to_i
      else
        @week_number = (Date.today.cweek - 0) 
      end
       if @week_number <= 0 then @week_number = 1 end
      logger.debug "load weekly chart called"
      @date_range_start = Date.commercial(Date.today.cwyear, @week_number, 1).strftime "%m/%d/%y"  # 1/19/09 (Monday)
      @date_range_end = Date.commercial(Date.today.cwyear, @week_number, 7).strftime "%m/%d/%y" # 1/25/09 (Sunday)
    
      reports = EffortLog.find_by_sql(["SELECT task_types.name, users.human_name, effort_log_line_items.sum FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id inner join users on users.id = person_id inner join task_types on task_type_id = task_types.id where course_id = ? and effort_logs.week_number = ? order by name, human_name", params[:id], @week_number])

      @labels_array = []
      labels_index_hash = {}
      
      reports.each do |line| 
        l_human_name = line.human_name
        if !labels_index_hash.has_key?(l_human_name)
          @labels_array << l_human_name
          labels_index_hash[l_human_name] = @labels_array.size
        end        
      end

      #if the user is a student, move them to be the first column of data
      if current_user && (!current_user.is_staff? && !current_user.is_admin?) then
        @labels_array.each_index do |i|
          if @labels_array[i] == current_user.human_name then
            labels_index_hash[@labels_array[0]] = i+1
            labels_index_hash[current_user.human_name] = 1
            @labels_array[i] = @labels_array[0]
            @labels_array[0] = current_user.human_name
          end
        end
        @labels_array.each_index do |i|
          if @labels_array[i] != current_user.human_name then
            @labels_array[i] = 'anonymous'
          end
        end
      end
 
      if request.env["Anonymous"] then
        @labels_array.each_index do |i|
           @labels_array[i] = 'anonymous'
          end
      end
      
      row_width = @labels_array.size + 1  #Plus one is the for an additional first column, the "type" label.
      current_task = ""
      current_task_chart_data_row = Array.new(row_width) {|i| "0.0" }
      @chart_data = []
      reports.each do |line|
        if line.name == current_task 
          current_task_chart_data_row[labels_index_hash[line.human_name]] = line.sum          
        else
          if current_task != "" then
            @chart_data << current_task_chart_data_row
            current_task_chart_data_row = Array.new(row_width) {|i| "0.0" }
          end
          current_task = line.name
          current_task_chart_data_row[0] = line.name 
          current_task_chart_data_row[labels_index_hash[line.human_name]] = line.sum
        end
      end
      @chart_data << current_task_chart_data_row
      
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :layout => false  }
      end
    end
    
    
    # Callback from the flash movie to get the chart's data
    def load_chart
#    if !(current_user.is_admin? || current_user.is_staff?)          
#      flash[:error] = 'You don''t have permissions to view this data.'
#      redirect_to(effort_reports_url)
#      return
#    end

      chart = Ziya::Charts::Line.new
      chart.add( :theme, "simple" ) 

      weeks_array = [35, 36, 37, 38, 39, 40, 41, 42]
       
#      reports = EffortLog.find_by_sql("SELECT effort_logs.week_number, users.human_name, sum(effort_log_line_items.sum), effort_log_line_items.course_id FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id inner join users on users.id = person_id inner join task_types on task_type_id = task_types.id where course_id = '7' group by week_number, human_name, course_id")
      reports = EffortLog.find_by_sql("SELECT effort_logs.week_number, users.human_name, task_types.name, effort_log_line_items.sum, effort_log_line_items.course_id FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id inner join users on users.id = person_id inner join task_types on task_type_id = task_types.id where course_id = '7'  order by week_number ")

      if reports.size != 0 then

        first_week = reports.first.week_number.to_i
        last_week = reports.last.week_number.to_i
        weeks_array = []
        (first_week..last_week).each do |week| weeks_array.push week end
        
  #      data is a hash of person -> week -> effort

        data = {}
        anonymous_counter = 1
        reports.each do |report| 
          r_human_name = report.human_name
          r_week_number = report.week_number.to_i
          r_sum = report.sum.to_i
          if data.has_key?(r_human_name) then
            time_hash = data[r_human_name]
          else
            time_hash = {}
          end
          if time_hash.has_key?(r_week_number) then
            time_hash[r_week_number] = time_hash[r_week_number] + r_sum
          else
            time_hash[r_week_number] = r_sum
          end
          data[r_human_name] = time_hash
        end
  #      chart.add( :axis_category_text, %w[2006 2007 2009] )


        chart.add( :axis_category_text, weeks_array )
        data.each do |human_name, time_hash|
          effort_array = []
          (first_week..last_week).each do |week| 
            if time_hash.has_key?(week) then
              effort_array.push(time_hash[week])
            else
              effort_array.push(0)
            end
          end
         if current_user && (!current_user.is_staff? && !current_user.is_admin?) then
            if human_name != current_user.human_name then
              human_name = "anonymous " + anonymous_counter.to_s
              anonymous_counter = anonymous_counter + 1
            end
          end         
          chart.add( :series, human_name, effort_array)
        end
      end
        
        #      data.each { |key,value| chart.add( :series, key, value)  }
#      chart.add( :series, "Dogs2", [10,20,30] )
#      chart.add( :series, "Cats", [5,15,25] )
      respond_to do |fmt|
        fmt.xml { render :xml => chart.to_xml }
      end
      
    end

   
  
  # GET /effort_reports
  # GET /effort_reports.xml
#  def index
#    authorize
#    @effort_logs = EffortLog.find(:all, :conditions => "person_id = '#{current_user.id}'", :order => "id DESC")
#
#    if @effort_logs.empty?
#       @show_new_link = true
#    else
#      if @effort_logs[0].year == Date.today.cwyear && @effort_logs[0].week_number == Date.today.cweek
#        @show_new_link = false
#      else
#        @show_new_link = true
#      end
#    end
#
#    
#    
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @effort_logs }
#    end
#  end

  
  # GET /effort_reports/1
  # GET /effort_reports/1.xml
  def raw_data
    if !(current_user.is_admin? || current_user.is_staff?)          
      flash[:error] = 'You don''t have permissions to view this data.'
      redirect_to(effort_reports_url)
      return
    end
    @report_lines = EffortLog.find_by_sql(["SELECT effort_logs.year, effort_logs.week_number, users.human_name, task_types.name, effort_log_line_items.sum, effort_log_line_items.course_id FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id inner join users on users.id = person_id inner join task_types on task_type_id = task_types.id where course_id = ?  order by week_number ", params[:id]])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @effort_log }
    end
  end

  
  
  def course_table
    if !(current_user.is_admin? || current_user.is_staff?)          
      flash[:error] = 'You don''t have permissions to view this data.'
      redirect_to(effort_reports_url)
      return
    end
    @course = Course.find(params[:id])

    #given the course id, determine the start week and the end week of the semester
 
    @report_header = ["Team", "Person"]
    (1..@course.semester_length).each do |week| @report_header << "Wk #{week} "  end
#    @course.semester_length.times do @report_header << "Wk  "  end
     
    @report_lines = []

    blank_line = Array.new(@course.semester_length, "-")
    min_effort = Array.new(@course.semester_length, 100)
    max_effort = Array.new(@course.semester_length, 0)
    total_effort = Array.new(@course.semester_length, 0)
    count_effort = Array.new(@course.semester_length, 0)
    average_effort = Array.new(@course.semester_length, 0)

    
    @course.teams.each do |team| 
       team.people.each do |person|
          person_result =  report_person_effort_for_course(person, @course)
          @report_lines << { :team_name => team.name, :person_name => person.human_name, :effort => person_result }                 
          min_effort = update_min(min_effort, person_result)
          max_effort = update_max(max_effort, person_result)
          total_effort = update_total(total_effort, person_result)
          count_effort = update_count(count_effort, person_result)
      end
    end
    update_average(average_effort, total_effort, count_effort)
    @report_lines << { :team_name => "", :person_name => "", :effort => blank_line }                 
    @report_lines << { :team_name => "Summary", :person_name => "Min", :effort => min_effort }                 
    @report_lines << { :team_name => "Summary", :person_name => "Avg", :effort => average_effort }                 
    @report_lines << { :team_name => "Summary", :person_name => "Max", :effort => max_effort }                 
    @report_lines << { :team_name => "", :person_name => "", :effort => blank_line }                 
    @report_lines << { :team_name => "Summary", :person_name => "Total", :effort => total_effort }                 
    @report_lines << { :team_name => "Summary", :person_name => "Count", :effort => count_effort }                 
    
  end
  
  # helper method for course_table
  def update_max(max_effort, person_result)
    max_effort.each_index {|i| max_effort[i] = person_result[i] if person_result[i] > max_effort[i]}
  end 
  def update_min(min_effort, person_result)
    min_effort.each_index {|i| min_effort[i] = person_result[i] if person_result[i] < min_effort[i] && person_result[i] > 0}
  end 
  def update_total(total_effort, person_result)
    total_effort.each_index {|i| total_effort[i] += person_result[i] }
  end 
  def update_count(count_effort, person_result)
    count_effort.each_index {|i| count_effort[i] += 1 if person_result[i] != 0 }
  end 
  def update_average(average_effort, total_effort, count_effort)
    average_effort.each_index {|i| average_effort[i] = total_effort[i] / count_effort[i] unless count_effort[i] == 0 }
  end 

  
  # helper method for course_table
  def report_person_effort_for_course(person, course)
    person_effort_log_lines = EffortLog.find_by_sql(["SELECT effort_logs.week_number, effort_log_line_items.sum  FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id where effort_log_line_items.course_id = ? and effort_logs.person_id = ? order by effort_logs.week_number", course.id, person.id])
    
    person_result = []
    @course.semester_length.times do person_result << 0 end
    if !person_effort_log_lines.nil? && person_effort_log_lines.size != 0 then
      person_effort_log_lines.each do |line|
        week = line.week_number.to_i 
        if week >= @course.semester_start && week <= @course.semester_end then
          person_result[week - @course.semester_start + 0] += line.sum.to_i  #add two to skip the team and person label at the front of the array
        end
        
      end

    end
    return person_result
  end


end
