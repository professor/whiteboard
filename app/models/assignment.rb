# Assignment is created by a professor for a course. A student or a team can
# submit one deliverable for each assignment.

class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :deliverables

  validates_presence_of :title
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_total_weights

  before_save :set_individual_to_unsubmittable
  before_validation :check_weight

  default_scope order: "task_number ASC, due_date ASC"

  accepts_nested_attributes_for :deliverables, allow_destroy: true

  def deliverable_for_user(user)
    if self.team_deliverable?
      team = Team.find_current_by_person_and_course(user, self.course)
      # find_by_team_id may find an individual deliverable if passed nil
      if !team.blank?
        deliverable = self.deliverables.find_by_team_id(team.id)
      end
    else
      deliverable = self.deliverables.find_by_creator_id(user.id)
    end

    deliverable
  end

  def find_deliverable_grade(user)
    deliverable = deliverable_for_user(user)
    deliverable.blank? ? nil : deliverable.deliverable_grades.find_by_user_id(user.id)
  end

  def submittable?
    self.can_submit
  end

  def formatted_title
    if self.task_number.blank? || (self.course.grading_nomenclature == "Assignments")
      self.title
    else
      "Task #{self.task_number}: #{self.title}"
    end
  end

  def max_score
    if self.course.grading_criteria == "Points"
      "#{self.weight} points"
    else
      "100"
    end
  end

  def find_or_create_deliverable_by_user(user)
    if self.submittable?
      if self.team_deliverable
        team = Team.find_current_by_person_and_course(user, self.course)
        deliverable = self.deliverables.find_by_team_id(team.id)
        if deliverable.blank?
          create_deliverable_for_team(user, team)
        else
          team.members.each do |member|
            if deliverable.deliverable_grades.find_by_user_id(member).blank?
              deliverable.deliverable_grades.create(user: member, grade: "0")
            end
          end
        end
      else # individual
        deliverable = self.deliverable_for_user(user)
        if deliverable.blank?
          create_deliverable_for_user(user)
        end
      end
    else # unsubmittable
      all_students = self.course.all_students.values
      all_students.each do |student|
        deliverable = self.deliverable_for_user(student)
        if deliverable.blank?
          create_deliverable_for_user(student)
        end
      end
    end

    deliverable_for_user(user)
  end

  private

    def create_deliverable_for_user(user)
      self.deliverables.create(creator: user, status: "Ungraded")
    end

    def create_deliverable_for_team(user, team)
      self.deliverables.create(creator: user, team: team, status: "Ungraded")
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

    def check_weight
      if self.weight.blank?
        self.weight = 0
      end
      true
    end

    def set_individual_to_unsubmittable
      if !self.submittable?
        self.team_deliverable = false
      end
      true
    end
end
