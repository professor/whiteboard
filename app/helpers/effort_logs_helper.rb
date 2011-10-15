module EffortLogsHelper

  def show_week_of_year_text
    "Week " + @effort_log.week_number + " of " + @effort_log.year
  end

  def show_monday_for(cwyear, week_number)
    Date.commercial(cwyear, week_number, 1).strftime "%b %d, %Y" # Jul 01, 2008
  end

  def td_class_is_today(day_of_week)
    @today_column == day_of_week ? "<td class='today'>".html_safe : "<td>".html_safe
  end


end
