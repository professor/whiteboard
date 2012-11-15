class AssignmentGrade < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment

  validates :user_id, presence: true
  validates :assignment_id, presence: true
  validates :given_grade, presence: true
  validate :valid_number_grade, :valid_letter_grade

  def given_grade=(given_grade)
    write_attribute(:given_grade=, given_grade.to_s)
  end

  def number_grade
    if is_numeric?
      self.given_grade.to_f
    else
      previous_grading_range_number = 100.0
      self.assignment.course.grading_ranges.each do |grading_range|
        if self.given_grade == grading_range.grade
          if self.assignment.course.grading_criteria == "Points"
            return (previous_grading_range_number / 100) * self.assignment.weight
          else
            return previous_grading_range_number
          end
        end
        previous_grading_range_number = (grading_range.minimum - 1).to_f
      end
      return 0
    end
  end

  def deliverable
    if self.assignment.can_submit?
      if self.assignment.team_deliverable?
        team = Team.find_current_by_person_and_course(self.user, self.assignment.course)
        # find_by_team_id may find an individual deliverable if passed nil
        if !team.blank?
          deliverable = self.assignment.deliverables.find_by_team_id(team.id)
        end
      else
        deliverable = self.assignment.deliverables.find_by_creator_id(self.user_id)
      end
    end

    deliverable.blank? ? nil : deliverable
  end

  private

  def valid_number_grade
    if is_numeric?
      if self.given_grade.to_f < 0
        self.errors.add(:grade, "Grade should be greater or equal to 0")
      end
    end
  end

  def valid_letter_grade
    if !is_numeric?
      valid_letter_grades = self.assignment.course.grading_ranges.map {|grading_range| grading_range.grade}

      if !valid_letter_grades.include?(self.given_grade)
        self.errors.add(:base, "Grade should be a grade in [#{valid_letter_grades.join(", ")}]")
      end
    end
  end

  def is_numeric?
    !!Float(self.given_grade) rescue false
  end
end
