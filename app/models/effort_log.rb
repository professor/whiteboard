class EffortLog < ActiveRecord::Base
  has_many :effort_log_line_items, :dependent => :destroy
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :week_number
  validates_presence_of :year

  before_save :determine_total_effort

  def self.find_effort_logs(current_user)
    where("user_id = '#{current_user.id}'").order("year DESC, week_number DESC")
  end

  def editable_by(current_user)
    if (current_user && current_user.is_admin?)
      return true
    end
    if (current_user && current_user.id == user_id)
      a = Date.today
      b = Date.commercial(self.year, self.week_number, 1)
      c = (Date.commercial(self.year, self.week_number, 7) + 1.day)
      if (Date.today >= Date.commercial(self.year, self.week_number, 1) && Date.today <= (Date.commercial(self.year, self.week_number, 7) + 1.day))
        return true
      end
    end
    return false
  end

  def validate_effort_against_registered_courses
    course_error_msg = ""
    registered_courses = self.user.registered_for_these_courses_during_current_semester()

    unregistered_courses = {}
    self.effort_log_line_items.each do |log_line_item|
      if (log_line_item.sum != 0)
        if (log_line_item.course.nil?)
          unregistered_courses["No course selected"] = 1
        elsif (!registered_courses.include?(log_line_item.course))
          unregistered_courses[log_line_item.course.name] = 1
        end
      end
    end
    course_error_msg = unregistered_courses.keys.join("<br/>") unless unregistered_courses.empty?
    return course_error_msg
  end

  def self.users_with_effort_against_unregistered_courses
    cweek = Date.today.cweek
    cyear = Date.today.cwyear

    sql_effort_logs_this_week = "SELECT e.* FROM effort_logs e,users u where e.week_number=#{cweek} and e.year=#{cyear} and u.id=e.user_id and u.is_student IS TRUE"

    effort_logs_this_week = EffortLog.find_by_sql(sql_effort_logs_this_week)
    @error_effort_logs_users = {}

    effort_logs_this_week.each do |effort_log|
      courses_in_error = effort_log.validate_effort_against_registered_courses()
      if (courses_in_error!="")
        @error_effort_logs_users[effort_log.user] = courses_in_error
      end
    end
    @error_effort_logs_users
  end


  def determine_total_effort
    self.sum = 0
    self.effort_log_line_items.each do |line|
      line.determine_total_effort
      self.sum = self.sum + line.sum
    end
  end


  def new_effort_log_line_item_attributes=(line_item_attributes)
    line_item_attributes.each do |attributes|
      effort_log_line_items.build(attributes)
    end
  end

  after_update :save_effort_log_line_items
  validates_associated :effort_log_line_items

  def existing_effort_log_line_item_attributes=(effort_log_line_item_attributes)
    effort_log_line_items.reject(&:new_record?).each do |effort_log_line_item|
      attributes = effort_log_line_item_attributes[effort_log_line_item.id.to_s]
      if attributes
        effort_log_line_item.attributes = attributes
      else
        effort_log_line_items.delete(effort_log_line_item)
      end
    end
  end

  def save_effort_log_line_items
    effort_log_line_items.each do |effort_log_line_item|
      effort_log_line_item.save(false)
    end
  end

  def self.log_effort_week?(year, week_number)
    if AcademicCalendar.spring_break(year).include?(week_number)
      return false
    else
      return AcademicCalendar.week_during_semester?(year, week_number)
    end
  end

  def self.latest_for_user(user_id, week_number, year)
    EffortLog.where("user_id = ? and week_number = ? and year = ?", user_id, week_number, year).first
  end

end
