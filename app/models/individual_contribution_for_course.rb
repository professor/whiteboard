class IndividualContributionForCourse < ActiveRecord::Base
  belongs_to :individual_contribution
  belongs_to :course

  validates_presence_of :individual_contribution_id
  validates_presence_of :course_id



  #
  #
  #
  #
  # def self.find_individual_contributions(current_user)
  #   where("user_id = ?", current_user.id).order("year DESC, week_number DESC")
  # end
  #
  #def self.find_by_week(year, week_number, current_user)
  #  where("year = ? AND week_number = ? AND user_id = ? " , year, week_number, current_user.id).first
  #end


  #def editable_by(current_user)
  #  if (current_user && current_user.is_admin?)
  #    return true
  #  end
  #  if (current_user && current_user.id == person_id)
  #    a = Date.today
  #    b = Date.commercial(self.year, self.week_number, 1)
  #    c = (Date.commercial(self.year, self.week_number, 7) + 1.day)
  #    if (Date.today >= Date.commercial(self.year, self.week_number, 1) && Date.today <= (Date.commercial(self.year, self.week_number, 7) + 1.day))
  #      return true
  #    end
  #  end
  #  return false
  #end
  #
  #def self.log_effort_week?(year, week_number)
  #  if AcademicCalendar.spring_break(year).include?(week_number)
  #    return false
  #  else
  #    return AcademicCalendar.week_during_semester?(year, week_number)
  #  end
  #end

end
