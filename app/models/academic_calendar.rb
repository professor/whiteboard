class AcademicCalendar

#
# Note: to check future dates, use the following code. Date.new(2010, 8, 23).cweek
#



  # Looking at the calendar, we want current_semester to have these characteristics
  # Spring starts roughly around Christmas and ends 1 week after last day of semester
  # Summer starts 1 week before and end 1 week after semester
  # Fall starts 1 week before and goes to roughly around Christmas
  def self.current_semester
    cweek = Date.today.cweek()
    return "Spring" if cweek < AcademicCalendar.semester_start("Summer", Date.today.cwyear) - 1 || cweek > 51
    return "Summer" if cweek < AcademicCalendar.semester_start("Fall", Date.today.cwyear) - 2
    return "Fall"
  end

  def self.next_semester
    case AcademicCalendar.current_semester
      when "Spring"
        return "Summer"
      when "Summer"
        return "Fall"
      when "Fall"
        return "Spring"
    end
  end

  def self.next_semester_year
    case AcademicCalendar.next_semester
     when "Spring"
      return Date.today.year + 1
    else
      return Date.today.year
    end
  end


  def self.week_during_semester?(year, week_number)
    case week_number
      when self.semester_start("Spring", year )..(self.semester_start("Spring", year )+15)
        return true
      when self.semester_start("Summer", year )..(self.semester_start("Summer", year )+11)
        return true
      when self.semester_start("Fall", year )..(self.semester_start("Fall", year )+15)
        return true
      else
        return false
    end
  end

  def self.log_effort_week?(year, week_number)
    case week_number
      when self.spring_break(year)
        return false
      else
        return self.week_during_semester?(year, week_number)
    end
  end

  def self.spring_break(year)
    case year
      when 2011
        return 9..10
      else
        return 9..10
    end
  end


  def self.semester_start(semester, year)

    case year
      when 2011
        case semester
          when "Spring"
            return 2
          when "Summer"
            return 20
          when "Fall"
            return 35
        end
      when 2010
        case semester
          when "Spring"
            return 2
          when "Summer"
            return 20
          when "Fall"
            return 34
        end
      when 2009
        case semester
          when "Spring"
            return 3
          when "Summer"
            return 21
          when "Fall"
            return 34
        end
      when 2008
        case semester
          when "Fall"
            return 35
        end

    end
    
  end


end