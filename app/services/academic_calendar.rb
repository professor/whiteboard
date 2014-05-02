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

  TERM_LENGTH = { "Fall"   => { "A" => 7, "B" => 7, "Both" => 15 },
                  "Spring" => { "A" => 7, "B" => 7, "Both" => 16 },
                  "Summer" => { "A" => 6, "B" => 6, "Both" => 12 } }

  SPRING_BREAK = { 2014 => 10..11, 2013 => 10..11, 2012 => 10..11, 2011 => 9..10, 2010 => 9..10 }

  SEMESTER_START = { 2015 => { "Spring" => 3, "Summer" => 21, "Fall" => 35 },
                     2014 => { "Spring" => 3, "Summer" => 21, "Fall" => 35 },
                     2013 => { "Spring" => 3, "Summer" => 21, "Fall" => 35 },
                     2012 => { "Spring" => 3, "Summer" => 21, "Fall" => 35 },
                     2011 => { "Spring" => 2, "Summer" => 20, "Fall" => 35 },
                     2010 => { "Spring" => 2, "Summer" => 20, "Fall" => 34 },
                     2009 => { "Spring" => 3, "Summer" => 21, "Fall" => 34 },
                     2008 => { "Spring" => 2, "Summer" => 16, "Fall" => 35 } }

  GRADES_DUE_FOR = { 2014 => { "Spring" => Date.new(2014, 5, 21),
                               "Summer" => Date.new(2014, 8, 12),
                               "Fall"   => Date.new(2014, 12, 18) },
                     2013 => { "Spring" => Date.new(2013, 5, 22),
                               "Summer" => Date.new(2013, 8, 13),
                               "Fall"   => Date.new(2013, 12, 18) },
                     2012 => { "Spring" => Date.new(2012, 5, 22),
                               "Summer" => Date.new(2012, 8, 14),
                               "Fall"   => Date.new(2012, 12, 20) },
                     2011 => { "Spring" => Date.new(2011, 5, 17),
                               "Summer" => Date.new(2011, 8, 9),
                               "Fall"   => Date.new(2011, 12, 22) },
                     2010 => { "Spring" => Date.new(2010, 5, 18),
                               "Summer" => Date.new(2010, 8, 10),
                               "Fall"   => Date.new(2010, 12, 16) } }


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
    if SPRING_BREAK[year].nil?
      options = {:to => "todd.sedano@sv.cmu.edu",
                 :subject => "Academic Calendar needs updating: spring_break",
                 :message => "Please modify app/services/AcademicCalendar.rb spring_break(#{year})",
                 :url_label => "",
                 :url => ""
      }
      GenericMailer.email(options).deliver
      return nil
    else
      return SPRING_BREAK[year]
    end
  end

  def self.term_length(semester, mini)
    TERM_LENGTH[semester][mini]
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
    if GRADES_DUE_FOR[year].nil?
      options = {:to => "todd.sedano@sv.cmu.edu",
                 :subject => "Academic Calendar needs updating: grades_due_for",
                 :message => "Please modify app/services/AcademicCalendar.rb grades_due_for(#{semester}, #{year})",
                 :url_label => "",
                 :url => ""
      }
      GenericMailer.email(options).deliver
    else
      GRADES_DUE_FOR[year][semester]
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
    if SEMESTER_START[year][semester].nil?
      options = {:to => "todd.sedano@sv.cmu.edu",
                 :subject => "Academic Calendar needs updating: semester_start",
                 :message => "Please modify app/models/AcademicCalendar.rb semester_start(#{semester}, #{year})",
                 :url_label => "",
                 :url => ""
      }
      GenericMailer.email(options).deliver
    else
      SEMESTER_START[year][semester]
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
