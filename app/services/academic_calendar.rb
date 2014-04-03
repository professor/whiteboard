class AcademicCalendar

#
# Note: to check future dates, use the following code. Date.new(2010, 8, 23).cweek
#


# Looking at the calendar, we want current_semester to have these characteristics
# Spring starts roughly around Christmas and ends 1 week after last day of semester
# Summer starts 1 week before and end 1 week after semester
# Fall starts 1 week before and goes to roughly around Christmas
#
# In reality, this should be based upon when grades are due.
  def self.current_semester_old
    cweek = Date.today.cweek()
    return "Spring" if cweek < AcademicCalendar.semester_start("Summer", Date.today.cwyear) - 1 || cweek > 51
    return "Summer" if cweek < AcademicCalendar.semester_start("Fall", Date.today.cwyear) - 1
    return "Fall"
  end

  def self.current_semester
    return "Spring" if Date.today <= AcademicCalendar.grades_due_for("Spring", Date.today.year)
    return "Summer" if Date.today <= AcademicCalendar.grades_due_for("Summer", Date.today.year)
    return "Fall"   if Date.today <= AcademicCalendar.grades_due_for("Fall", Date.today.year)
    return "Spring"
  end

  def self.current_semester_year
    cweek = Date.today.cweek()
    if cweek > 51
      Date.today.cwyear + 1
    else
      Date.today.cwyear
    end
  end

  def self.current_mini
    cweek = Date.today.cweek()
    cwyear = Date.today.cwyear()

    spring_a = AcademicCalendar.semester_start("Spring", cwyear)
    summer_a = AcademicCalendar.semester_start("Summer", cwyear)
    fall_a = AcademicCalendar.semester_start("Fall", cwyear)

    case cweek
      when (spring_a)..(spring_a + 6) then
        "A"
      when (spring_a + 9)..(spring_a + 15) then
        "B"

      when (summer_a)..(summer_a + 5) then
        "A"
      when (summer_a + 6)..(summer_a + 11) then
        "B"

      when (fall_a)..(fall_a + 6) then
        "A"
      when (fall_a + 8)..(fall_a + 14) then
        "B"
      else
        "Unknown"
    end
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
    if AcademicCalendar.next_semester == "Spring" || Date.today.cweek > 51
        return Date.today.cwyear + 1
      else
        return Date.today.cwyear
    end
  end

  def self.next_semester_is_soon
    case self.current_mini
      when "A"
        false
      when "B"
        true
      when "Unknown"
        true
      else
        true
    end
  end

  def self.week_during_semester?(year, week_number)
    case week_number
      when self.semester_start("Spring", year)..(self.semester_start("Spring", year)+16)
        return true
      when self.semester_start("Summer", year)..(self.semester_start("Summer", year)+11)
        return true
      when self.semester_start("Fall", year)..(self.semester_start("Fall", year)+15)
        return true
      else
        return false
    end
  end

  def self.spring_break(year)
    case year
      when 2014
        return 10..11
      when 2013
        return 10..11
      when 2012
        return 10..11
      when 2011
        return 9..10
      when 2010
        return 9..10
      else
        options = {:to => "todd.sedano@sv.cmu.edu",
                   :subject => "Academic Calendar needs updating: spring_break",
                   :message => "Please modify app/services/AcademicCalendar.rb spring_break(#{year})",
                   :url_label => "",
                   :url => ""
        }
        GenericMailer.email(options).deliver
        return nil
    end
  end


  def self.term_length(semester, mini)
    case semester
      when "Fall"
        case mini
          when "A"
            7
          when "B"
            7
          when "Both"
            15
        end
      when "Spring"
        case mini
          when "A"
            7
          when "B"
            7
          when "Both"
            16
        end
      when "Summer"
        case mini
          when "A"
            6
          when "B"
            6
          when "Both"
            12
        end
    end
  end

  def self.break_length_between_minis(semester)
    case semester
      when "Fall"
        1
      when "Spring"
        2
      when "Summer"
        0
    end
  end

  def self.grades_due_for(semester, year)
    case year
      when 2014
      case semester
        when "Spring"
          return Date.new(2014, 5, 21) #Academic calendar doesn't exaclty say?
        when "Summer"
          return  Date.new(2014, 8, 12)
        when "Fall"
          return  Date.new(2014, 12, 18)
      end      
      when 2013
        case semester
          when "Spring"
            return Date.new(2013, 5, 22)
          when "Summer"
            return  Date.new(2013, 8, 13)
          when "Fall"
            return  Date.new(2013, 12, 18)
        end
      when 2012
        case semester
          when "Spring"
            return Date.new(2012, 5, 22)
          when "Summer"
            return  Date.new(2012, 8, 14)
          when "Fall"
            return  Date.new(2012, 12, 20)
        end
      when 2011
        case semester
          when "Spring"
            return Date.new(2011, 5, 17)
          when "Summer"
            return  Date.new(2011, 8, 9)
          when "Fall"
            return  Date.new(2011, 12, 22)
        end
      when 2010
        case semester
          when "Spring"
            return Date.new(2010, 5, 18)
          when "Summer"
            return  Date.new(2010, 8, 10)
          when "Fall"
            return  Date.new(2010, 12, 16)
        end
      else
        options = {:to => "todd.sedano@sv.cmu.edu",
                   :subject => "Academic Calendar needs updating: grades_due_for",
                   :message => "Please modify app/services/AcademicCalendar.rb grades_due_for(#{semester}, #{year})",
                   :url_label => "",
                   :url => ""
        }
        GenericMailer.email(options).deliver
    end


  end

  #Historically we have used semester start to determine what is the current semester, moving forward, lets do this
  #around the grades due deadline


  # First day of class
  # August 26, 2013
  # January 13, 2014
  # May 19, 2014

  # Last day of class
  # December 6, 2013
  # May 2, 2013
  # August 7, 2014

  def self.semester_start(semester, year)
    case year
      when 2015
        case semester
          when "Spring" #Not official yet (4/1/2014)
            return 3
          when "Summer" #Not official yet (4/1/2014)
            return 21
          when "Fall" #Not official yet (4/1/2014)
            return 35
        end
      when 2014
        case semester
          when "Spring"
            return 3
          when "Summer"
            return 21
          when "Fall" #Not official yet (1/2/2012)
            return 35
        end
      when 2013
        case semester
          when "Spring"
            return 3
          when "Summer"
            return 21
          when "Fall"
            return 35
        end
      when 2012
        case semester
          when "Spring"
            return 3
          when "Summer"
            return 21
          when "Fall"
            return 35
        end
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
      when 2008 #This calendar is not aligned to the CMU Pittsburgh calendar
        case semester
          when "Spring"
            return 2
          when "Summer"
            return 16
          when "Fall"
            return 35
        end
      else
        options = {:to => "todd.sedano@sv.cmu.edu",
                   :subject => "Academic Calendar needs updating: semester_start",
                   :message => "Please modify app/services/AcademicCalendar.rb semester_start(#{semester}, #{year})",
                   :url_label => "",
                   :url => ""
        }
        GenericMailer.email(options).deliver
    end

  end

  def self.date_for_semester_start(semester, year)
    cweek = semester_start(semester, year)
    Date.commercial(year, cweek)
  end

  def self.date_for_semester_end(semester, year)
    cweek = semester_start(semester, year)
    cweek += self.term_length(semester, "Both")
    Date.commercial(year, cweek, 5) #Friday
  end

  def self.date_for_mini_start(semester, mini, year)
    cweek = semester_start(semester, year)
    if mini == "B"
      cweek += self.term_length(semester, mini) - 1
      cweek += self.break_length_between_minis(semester) + 1
    end
    Date.commercial(year, cweek, 1)
  end

  def self.date_for_mini_end(semester, mini, year)
    cweek = semester_start(semester, year)
    cweek += self.term_length(semester, "A") - 1
    if mini == "B"
      cweek += self.break_length_between_minis(semester)
      cweek += self.term_length(semester, mini)
    end
    Date.commercial(year, cweek, 5) #Friday
  end

  # F12, S12, M12
  def self.parse_HUB_semester(short_form)
    return "", "" if short_form.blank?

    case short_form[0]
      when 'F'
        semester = 'Fall'
      when 'S'
        semester = 'Spring'
      when 'M'
        semester = 'Summer'
      else
        semester = ""
    end

    year = '20' + short_form[1..2]
    year = year.to_i
    year = "" if year == 20

    return semester, year
  end

  def self.parse_semester_and_year(semester_year_string)
    semester = semester_year_string[0..-5]
    semester = semester.capitalize if semester
    year = semester_year_string[-4..-1].to_i
    year = "" if year == 0
    return semester, year
  end


  def self.valid_semester_and_year(string)
    (semester, year) = self.parse_semester_and_year(string)
    (semester, year) = self.parse_HUB_semester(string) if (semester.empty? || year.is_a?(String))

    semester = "" unless ["Fall", "Summer", "Spring"].include?(semester)
    if year.is_a?(Fixnum)
      year = "" unless year > 2007 && year <= (Date.today.year + 1)
    end

    return semester, year
  end

end
