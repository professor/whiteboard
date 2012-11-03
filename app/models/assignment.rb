# Assignment is created by a professor for a course. A student or a team can
# submit one deliverable for each assignment.

class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :deliverables

  validates_presence_of :title
  validates :weight, numericality: { greater_than: 0 }, presence: true
  validate :validate_due_date, :validate_total_weights

  after_save :create_placeholder_deliverable

  default_scope order: "task_number ASC, due_date ASC"

  def find_deliverable_grade(user)
    if !self.can_submit
      deliverable = self.deliverables.first
    elsif self.team_deliverable?
      team = Team.find_current_by_person_and_course(user, self.course)
      # find_by_team_id may find an individual deliverable if passed nil
      if !team.blank?
        deliverable = self.deliverables.find_by_team_id(team.id)
      end
    else
      if self.can_submit?
        deliverable = self.deliverables.find_by_creator_id(user.id)
      else
        deliverable = self.deliverables.first
      end
    end

    deliverable.blank? ? nil : deliverable.deliverable_grades.find_by_user_id(user.id)
  end

  def submittable?
    self.can_submit && self.due_date > DateTime.now
  end

  def formatted_title
    if self.task_number.blank?
      self.title
    else
      "Task #{self.task_number}: #{self.title}"
    end
  end

  def create_placeholder_deliverable
    if !self.can_submit? && self.deliverables.empty?
      # Create a placeholder deliverable for an assignment that does not accept deliverables from students
      self.deliverables.create(creator_id: self.course.faculty_assignments.first.user.id, status: "Ungraded")
      self.course.registered_students.each do |student|
        student.deliverable_grades.create(grade: 0, deliverable_id: self.deliverables.first.id)
      end
    end
  end

  private

    def validate_due_date
      if self.can_submit?
        if self.due_date.nil?
          self.errors.add(:due_date, "Empty due date")
        else
          if self.due_date <= DateTime.now
            self.errors.add(:due_date, "Due date earlier than now")
          end
        end
      end
    end

    def validate_total_weights
      if self.course.grading_criteria == "Percentage"

        assignments = Assignment.find_all_by_course_id(self.course_id).delete_if {|assignment| assignment.id == self.id}
        sum = 0

        assignments.each do |assignment|
          sum += assignment.weight
        end

        sum += self.weight if !self.weight.blank?

        if sum > 100
         self.errors.add(:weight, "The sum of all assignment weights for this course is greater than 100")
        end
      end
    end
end
