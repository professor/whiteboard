class EffortReportsController < ApplicationController

  layout 'cmu_sv', :only => [:index, :show, :campus_semester, :campus_week, :course]

  before_filter :authenticate_user!

  class PanelState
    attr_accessor :year, :week_number, :course_id, :date
  end
  class SemesterPanel
    attr_accessor :program, :track, :graduation_year, :is_part_time, :person_id, :course_id, :semester, :year

    def generate_sql(just_student = nil)

      if (self.course_id.blank?)
        sql_statement = "select distinct el.week_number, el.sum as student_effort, el.user_id "
      else
        sql_statement = "select el.week_number, e.sum as student_effort, el.user_id "
      end
      sql_statement = sql_statement + "from effort_log_line_items e, effort_logs el,courses c, users u
      where e.sum>0 and e.course_id=c.id and e.effort_log_id=el.id and el.user_id= u.id and el.year=c.year"
      sql_statement = sql_statement + " AND el.year=#{self.year}"
      sql_statement = sql_statement + " and e.course_id=#{self.course_id}" unless self.course_id.blank?
      sql_statement = sql_statement + " and c.semester='#{self.semester}'"
      sql_statement = sql_statement + " and u.graduation_year='#{self.graduation_year}'" unless self.graduation_year.blank?
      sql_statement = sql_statement + " and u.masters_program='#{self.program}'" unless self.program.blank?
      sql_statement = sql_statement + " and u.masters_track='#{self.track}'" unless self.track.blank?
      case self.is_part_time
        when "PT"
          sql_statement = sql_statement + " and u.is_part_time is true"
        when "FT"
          sql_statement = sql_statement + " and u.is_part_time is false"
      end
      sql_statement = sql_statement + " and el.user_id=#{self.person_id}" if just_student && !self.person_id.blank?

      sql_statement = sql_statement + " order by el.week_number"
      return sql_statement
    end
  end

  def get_course_data(year, week_number, course_id)
    effort_logs = EffortLog.find_by_sql("select task_type_id, t.name, e.sum as student_effort from effort_log_line_items e,effort_logs el,task_types t where e.sum>0 and e.task_type_id=t.id and e.effort_log_id=el.id AND el.year=#{year} and el.week_number=#{week_number} AND e.course_id=#{course_id} order by task_type_id;")

    task_type_id_to_value_array_hash = {}
    effort_logs.each do |effort_log|
      key = effort_log.task_type_id
      value = effort_log.student_effort.to_f
      task_type_id_to_value_array_hash[key] = [] if task_type_id_to_value_array_hash[key].nil?
      task_type_id_to_value_array_hash[key] << value
    end

    values_array = []
    task_type_id_to_value_array_hash.each do |task_type_id, values|
      values_array << ([TaskType.find(task_type_id).name] + course_ranges_array(values))
    end
    return values_array
  end


  def get_campus_week_data(year, week_number)
    effort_logs = EffortLog.where("week_number=? AND year=? AND sum>0", week_number.to_i, year.to_i)

    course_id_to_value_array_hash = {}
    effort_logs.each do |effort_log|
      course_to_person_hash = {}
      effort_log.effort_log_line_items.each do |line_item|
        unless line_item.course_id == nil
          course_to_person_hash[line_item.course_id] = 0 if course_to_person_hash[line_item.course_id].nil?
          course_to_person_hash[line_item.course_id] += line_item.sum
        end
      end
      course_to_person_hash.each do |course_id, sum|
        course_id_to_value_array_hash[course_id] = [] if course_id_to_value_array_hash[course_id].nil?
        course_id_to_value_array_hash[course_id] << sum
      end
    end

    values_array = []
    course_id_to_value_array_hash.each do |course_id, values|
      values_array << ([Course.find_by_id(course_id).short_or_full_name] + course_ranges_array(values))
    end
    return values_array
  end


  def get_campus_semester_data(panel)
    logger.debug panel.generate_sql()

    effort_logs = EffortLog.find_by_sql(panel.generate_sql())

    #The data we get is not sorted by week number and it is indexed by the commercial week of the year
    #At the beginning of a semester we want to show all the weeks in a semester
    #So we need to do a little calculation to figure out which week to start and end.

    #The code is not adding multiple entries per student together. Ie meetings and working on deliverables for a course

    unless effort_logs.blank?
      first_dataset_week_number = effort_logs.first.week_number
      last_dataset_week_number = effort_logs.last.week_number
      weeks_in_semester = 15
      weeks_in_report = [weeks_in_semester, (last_dataset_week_number - first_dataset_week_number + 1)].max
    else
      weeks_in_report = 15
    end


    # When the view is for only one course, a student will have logged effort for different types (meetings, deliverable)
    # Each of these is a row in the returnset, so we need to add up all the effort the student did for that course for
    # a given week
    student_effort_accumulator = {}
    effort_logs.each do |effort_log|
      key = [effort_log.week_number - first_dataset_week_number, effort_log.user_id]
      value = effort_log.student_effort.to_f
      if student_effort_accumulator[key].nil?
        student_effort_accumulator[key] = value
      else
        student_effort_accumulator[key] = student_effort_accumulator[key] + value
      end
    end

    week_number_to_value_array_array = []
    person_hours = []
    weeks_in_report.times do |i|
      week_number_to_value_array_array[i] = []
      person_hours[i] = 0
    end

    student_effort_accumulator.each do |array, hours|
      key = array[0] #week_number
      value = hours
      week_number_to_value_array_array[key] = [] if week_number_to_value_array_array[key].nil?
      week_number_to_value_array_array[key] << value
    end

    #Determine the effort for a particular, selected student
    unless panel.person_id.blank?
      a = panel.person_id
      student_effort_accumulator.each do |array, hours|
        week_number = array[0]
        person_id = array[1]
        person_hours[week_number] = hours if panel.person_id == person_id
      end
    end

    values_array = []
    week_number_to_value_array_array.each_index do |week_number|
      values = week_number_to_value_array_array[week_number]
      unless panel.person_id.blank?
        values_array << ([week_number + 1] + course_ranges_array(values) + [person_hours[week_number]])
      else
        values_array << ([week_number + 1] + course_ranges_array(values))
      end
    end

    return values_array
  end


#  def box_chart_helper(reports, multiplier)
##        return "-1,"+ values.map{|v| (v ? "%.2f" % (v*multiplier):0)}.join(",") + ",-1"
#    puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#    puts reports.values.join(",")
#    puts reports.keys.join(",")
#    str = "-1,"
#    reports.keys.sort.each do |key|
#      v = reports[key]
#      #puts "LENNNNNNNNNNNN %d" % v.length
#      if !v.nil?
#        puts v
#        #str = str + (!v.nil? ? ("%.2f" % (v*multiplier)) : 0.0).to_s  + ","
#        str = str + "%.2f" % (v*multiplier) + ","
#      else
#        puts "=EMPTY="
#        str = str + "0,"
#      end
#    end
#    str += "-1"
#    return str
#  end


  def generate_google_box_chart(title, reports)
    title_str = title.gsub(' ', '+')

    # Datastructure of the reports
    # array: [course_name, min, 25, median, 75, max]
    # array: [course_name, min, 25, median, 75, max, student_data] #used in campus semester view

    if reports && reports.size > 0
      max_value = reports.collect { |r| r[5] }.max

      multiplier = 100.0/(max_value)
      multiplier = 1 if max_value <= 0.0

      minimums_str = "-1," + reports.collect { |r| "%.2f"%(r[1]*multiplier) }.join(",")+",-1"
      lower25_str = "-1," + reports.collect { |r| "%.2f"%(r[2]*multiplier) }.join(",")+",-1"
      medians_str = "-1," + reports.collect { |r| "%.2f"%(r[3]*multiplier) }.join(",")+",-1"
      upper25_str = "-1," + reports.collect { |r| "%.2f"%(r[4]*multiplier) }.join(",")+",-1"
      maximums_str = "-1," + reports.collect { |r| "%.2f"%(r[5]*multiplier) }.join(",")+",-1"
      if reports.first[6].blank?
        outliers_str = ""
      else
        outliers_str = "|-1," + reports.collect { |r| "%.2f"%(r[6]*multiplier) }.join(",")+",-1"
      end

      labels_str = "|"+reports.collect { |r| r[0] }.join("|")+"|"

      url = "http://chart.apis.google.com/chart?chtt="+title_str+"&chxt=x,y&chs=700x400&cht=lc&chd=t0:" +
          minimums_str + "|" + lower25_str + "|" + upper25_str + "|" + maximums_str + "|" + medians_str + outliers_str +
          "&chl=" + labels_str + #get course_id and course_name from DB
          "&chm=F,FF9900,0,-1,25|H,0CBF0B,0,-1,1:10|H,000000,4,-1,1:25|H,0000FF,3,-1,1:10" +
          "|o,FF0000,5,-1,7|o,FF0000,6,-1,7" +
          "&chxr=1,0," + (max_value).to_s
      return url
    else
      return "http://chart.apis.google.com/chart?chtt="+ title_str+ "&chxt=x,y&chs=700x400&cht=lc&chd=t0:-1,0,0,0,-1|-1,0,0,0,-1|-1,0,0,0,-1|-1,0,0,0,-1|-1,0,0,0,-1&chm=F,FF9900,0,-1,25|H,0CBF0B,0,-1,1:10|H,000000,4,-1,1:25|H,0000FF,3,-1,1:10&chxr=1,0,15"
    end
  end

  def determine_panel_state
    if params[:panel_state]
      @panel_state = PanelState.new
      @panel_state.year = params[:panel_state][:year]
      @panel_state.week_number = params[:panel_state][:week_number]
      @panel_state.date = params[:panel_state][:date]
      logger.debug(params[:panel_state][:date])
      if !@panel_state.date.blank?
        panel_date = Date.parse(@panel_state.date)
        @panel_state.year = panel_date.cwyear
        @panel_state.week_number = panel_date.cweek

      end
    else
      @panel_state = PanelState.new
      @panel_state.year = Date.today.cwyear
      @panel_state.week_number = Date.today.cweek - 1
    end
  end

  def campus_semester
    if params[:semester_panel]
      @semester_panel = SemesterPanel.new
      @semester_panel.program = params[:semester_panel][:program]
      @semester_panel.track = params[:semester_panel][:track]
      @semester_panel.graduation_year = params[:semester_panel][:graduation_year]
      @semester_panel.is_part_time = params[:semester_panel][:is_part_time]
      @semester_panel.person_id = params[:semester_panel][:person_id].to_i unless params[:semester_panel][:person_id].blank?
      @semester_panel.course_id = params[:semester_panel][:course_id].to_i unless params[:semester_panel][:course_id].blank?
      @semester_panel.semester = params[:semester_panel][:semester]
      @semester_panel.year = params[:semester_panel][:year]
    else
      @semester_panel = SemesterPanel.new
      @semester_panel.program = current_user.is_student ? current_user.masters_program : "SE"
      @semester_panel.track = ""
      @semester_panel.graduation_year = ""
      @semester_panel.is_part_time = current_user.is_student && !current_user.is_part_time ? "FT" : "PT"
      @semester_panel.person_id = current_user.is_student ? current_user.id : ""
      @semester_panel.course_id = ""
      @semester_panel.semester = AcademicCalendar.current_semester
      @semester_panel.year = Date.today.cwyear
    end

    if current_user.is_staff || current_user.is_admin
      @students = Person.where(:is_student => true).order("first_name ASC, last_name ASC")
    else
      @students = [current_user]
    end
    @courses = Course.where(:semester => @semester_panel.semester, :year => @semester_panel.year).order("name ASC")
    @programs = []

    ActiveRecord::Base.connection.execute("SELECT distinct masters_program FROM users u;").each do |result|
      @programs << result["masters_program"]
    end
    @tracks = []
    ActiveRecord::Base.connection.execute("SELECT distinct masters_track FROM users u;").each do |result|
      @tracks << result["masters_track"]
    end

    title = "Campus View - " + @semester_panel.semester + " " + @semester_panel.year.to_s
    reports = get_campus_semester_data(@semester_panel)
    @chart_url = generate_google_box_chart(title, reports)


    respond_to do |format|
      if params[:layout]
        format.html { render :layout => false } # index.html.erb
      else
        format.html { render :layout => "cmu_sv" } # index.html.erb
      end
    end
  end


  def campus_week
    determine_panel_state()
    title = "Campus View - Week " + @panel_state.week_number.to_s + " of " + @panel_state.year.to_s
    course_data = get_campus_week_data(@panel_state.year, @panel_state.week_number)
    @chart_url = generate_google_box_chart(title, course_data)
  end


  def course
    determine_panel_state()
    if params[:panel_state]
      @panel_state.course_id = params[:panel_state][:course_id]
    else
      @panel_state.course_id = params[:course_id]

      if @panel_state.year.blank?
        @panel_state.year = Date.today.cwyear
      end

      if @panel_state.week_number.blank?
        @panel_state.week_number = Date.today.cweek - 1
      end

    end
    puts "PAREMETERS: #{@panel_state.year}, #{@panel_state.week_number}, #{params[:course_id]}"
    @chart_url = generate_course_chart(@panel_state.year, @panel_state.week_number, @panel_state.course_id)

    @course = Course.find(params[:course_id])
  end


  def generate_course_chart(year, week_number, course_id)
    course = Course.where(:id => course_id).first
    if course
      title = course.name
    else
      title = "Course Does Not Exist"
    end
    reports = get_course_data(year, week_number, course_id)
    return generate_google_box_chart(title, reports)
  end


  def index
  end

  def show_week
    if params[:week]
      @week_number = params[:week].to_i
    else
      @week_number = Date.today.cweek
    end

    if @week_number <= 0 then
      @week_number = 1
    end
    if @week_number >52 then
      @week_number = @week_number - 52
    end

    @next_week_number = @week_number + 1
    @prev_week_number = @week_number - 1
  end

  def show
  end


#  def load_google_chart
#
#    GoogleChart::BoxChart.new('800x200', "Box Chart") do |bc|
#      bc.data "s1",[-1,5,10,7,12,-1]
#      bc.data "s2",[-1,25,30,27,24,-1]
#      bc.data "s3",[-1,40,45,47,39,-1]
#      bc.data "s4",[-1,55,63,59,80,-1]
#      bc.data "s5",[-1,30,40,35,30,-1]
#      bc.data "s6",[-1,-1,5,70,90,-1]
#      bc.data "s7",[-1,-1,-1,80,5,-1]
#      bc.data_encoding = :text
#      @chart = bc.to_url(:chm => "F,FF9900,0,1:4,40|H,0CBF0B,0,1:4,1:20|H,000000,4,1:4,1:40|H,0000FF,3,1:4,1:20|o,FF0000,5,-1,7|o,FF0000,6,-1,7")
#    end
#
#
#  end

  def raw_data
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = 'You don' 't have permissions to view this data.'
      redirect_to(effort_reports_url)
      return
    end
    @report_lines = EffortLog.find_by_sql(["SELECT effort_logs.year, effort_logs.week_number, users.human_name, task_types.name, effort_log_line_items.sum, effort_log_line_items.course_id FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id inner join users on users.id = user_id inner join task_types on task_type_id = task_types.id where course_id = ?  order by week_number ", params[:id]])
  end


  def course_table
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = 'You don' 't have permissions to view this data.'
      redirect_to(effort_reports_url)
      return
    end
    @course = Course.find(params[:id])

    #given the course id, determine the start week and the end week of the semester

    @report_header = ["Team", "Person"]
    (1..@course.course_length).each do |week|
      @report_header << "Wk #{week} "
    end
    #    @course.course_length.times do @report_header << "Wk  "  end

    @report_lines = []

    blank_line = Array.new(@course.course_length, "-")
    min_effort = Array.new(@course.course_length, 100)
    max_effort = Array.new(@course.course_length, 0)
    total_effort = Array.new(@course.course_length, 0)
    count_effort = Array.new(@course.course_length, 0)
    average_effort = Array.new(@course.course_length, 0)


    @course.teams.each do |team|
      team.members.each do |user|
        person_result = report_person_effort_for_course(user, @course)
        @report_lines << {:team_name => team.name, :person_name => user.human_name, :effort => person_result}
        min_effort = update_min(min_effort, person_result)
        max_effort = update_max(max_effort, person_result)
        total_effort = update_total(total_effort, person_result)
        count_effort = update_count(count_effort, person_result)
      end
    end
    update_average(average_effort, total_effort, count_effort)
    @report_lines << {:team_name => "", :person_name => "", :effort => blank_line}
    @report_lines << {:team_name => "Summary", :person_name => "Min", :effort => min_effort}
    @report_lines << {:team_name => "Summary", :person_name => "Avg", :effort => average_effort}
    @report_lines << {:team_name => "Summary", :person_name => "Max", :effort => max_effort}
    @report_lines << {:team_name => "", :person_name => "", :effort => blank_line}
    @report_lines << {:team_name => "Summary", :person_name => "Total", :effort => total_effort}
    @report_lines << {:team_name => "Summary", :person_name => "Count", :effort => count_effort}

  end

  # helper method for course_table
  def update_max(max_effort, person_result)
    max_effort.each_index { |i| max_effort[i] = person_result[i] if person_result[i] > max_effort[i] }
  end

  def update_min(min_effort, person_result)
    min_effort.each_index { |i| min_effort[i] = person_result[i] if person_result[i] < min_effort[i] && person_result[i] > 0 }
  end

  def update_total(total_effort, person_result)
    total_effort.each_index { |i| total_effort[i] += person_result[i] }
  end

  def update_count(count_effort, person_result)
    count_effort.each_index { |i| count_effort[i] += 1 if person_result[i] != 0 }
  end

  def update_average(average_effort, total_effort, count_effort)
    average_effort.each_index { |i| average_effort[i] = total_effort[i] / count_effort[i] unless count_effort[i] == 0 }
  end


  # helper method for course_table
  def report_person_effort_for_course(person, course)
    person_effort_log_lines = EffortLog.find_by_sql(["SELECT effort_logs.week_number, effort_log_line_items.sum  FROM effort_log_line_items inner join effort_logs on effort_log_line_items.effort_log_id = effort_logs.id where effort_log_line_items.course_id = ? and effort_logs.user_id = ? order by effort_logs.week_number", course.id, person.id])

    person_result = []
    @course.course_length.times do
      person_result << 0
    end
    if !person_effort_log_lines.nil? && person_effort_log_lines.size != 0 then
      person_effort_log_lines.each do |line|
        week = line.week_number.to_i
        if week >= @course.course_start && week <= @course.course_end then
          person_result[week - @course.course_start + 0] += line.sum.to_i #add two to skip the team and person label at the front of the array
        end

      end

    end
    return person_result
  end

  def course_ranges_array(data_set) # data_set is an array of Numeric objects
    return [0, 0, 0, 0, 0] if data_set.blank?
    data_set = data_set.sort
    maximum = data_set.max
    minimum = data_set.min
    median = median(data_set)
    if data_set.count % 2 == 1
      lower25 = median(data_set[0..((data_set.count / 2).ceil)], 0.25)
      upper25 = median(data_set[((data_set.count / 2).floor)..-1], 0.75)
    else
      lower25 = median(data_set[0...(1 + data_set.count / 2)], 0.25)
      upper25 = median(data_set[(-1 + data_set.count / 2)..-1], 0.75)
    end

    [minimum, lower25, median, upper25, maximum]
  end

  def median(data_set, pct = 0.5)
    middle = (data_set.count + 1)/2.0
    middle -= 1 # convert from set index to array index (count from 0)
    if data_set.nil? or data_set.count == 0
      nil
    elsif data_set.count == 1
      data_set[0]
    elsif data_set.count % 2 == 1
      data_set[middle.floor]
    else
      data_set[middle.floor] + (pct * (data_set[middle.ceil] - data_set[middle.floor]))
    end
  end


end
