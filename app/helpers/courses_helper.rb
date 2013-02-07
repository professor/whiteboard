module CoursesHelper
  def nomenclature_assignment_or_deliverable
    @course.nil? ? "Deliverable" : @course.nomenclature_assignment_or_deliverable.capitalize
  end

  def grade_type_points_or_weights
    @course.nil? ? "Points" : @course.grade_type_points_or_weights.capitalize
  end
end
