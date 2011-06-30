module EffortLogsHelper
    
  def add_line_item_link(name)
    link_to name,
      :url => {:action => 'new_effort_log_line_item', :effort_log_id => @effort_log.id },
      :remote => true,
      :update => 'add_line_item',
      :position => :before
  end
  
  def add_time_sheet_line_item_link(name)
    link_to_function name do |page|
      page.insert_html :before, :add_line_item, :partial => 'time_sheet_line_item', :object => EffortLogLineItem.new, :local=>@courses
    end
  end

  def show_week_of_year_text
    "Week " + @effort_log.week_number + " of " + @effort_log.year 
  end

  def show_monday_for(cwyear, week_number)
      Date.commercial(cwyear, week_number, 1).strftime "%b %d, %Y"  # Jul 01, 2008
  end
    
  def td_class_is_today(day_of_week)
     @today_column == day_of_week ? "<td class='today'>".html_safe : "<td>".html_safe
  end
  
#  def td_class_is_today(day_of_week)
#    if @today_column == day_of_week  
#      return "<td class='today'>" 
#    else return "<td>" 
#    end
#  end
 
  
end
