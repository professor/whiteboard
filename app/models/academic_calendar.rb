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
    return "Summer" if cweek < AcademicCalendar.semester_start("Fall", Date.today.cwyear) - 1
    return "Fall"
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

  def self.school_year_semesters
    current_semester = self.current_semester
    if current_semester == 'Fall'
      return ["Fall-#{Date.today.year}", "Spring-#{Date.today.year + 1}", "Summer-#{Date.today.year + 1}"]
    else
      return ["Fall-#{Date.today.year - 1}", "Spring-#{Date.today.year}", "Summer-#{Date.today.year}"]
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
      when 2012
        return 10..11
      when 2011
        return 9..10
      when 2010
        return 9..10
      else
        options = {:to => "todd.sedano@sv.cmu.edu",
                   :subject => "Academic Calendar needs updating: spring_break",
                   :message => "Please modify app/models/AcademicCalendar.rb spring_break(#{year})",
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

  def self.semester_start(semester, year)

    case year
      when 2013
        case semester
          when "Spring"
            return 3
          when "Summer"
            return 21
          when "Fall" #Not official yet (1/2/2012)
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
                   :message => "Please modify app/models/AcademicCalendar.rb semester_start(#{semester}, #{year})",
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
      year = "" unless year > 2007 && year < (Date.today.year + 1)
    end

    return semester, year
  end

end
