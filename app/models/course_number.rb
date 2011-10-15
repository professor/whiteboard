class CourseNumber < ActiveRecord::Base

  def display_name
    return self.name if self.short_name.blank?
    return self.name + " (" + self.short_name + ")"
  end

end
