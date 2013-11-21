module CoursesHelper
  def nomenclature_assignment_or_deliverable
    @course.nil? ? "Deliverable" : CourseService.nomenclature_assignment_or_deliverable(@course).capitalize
  end

  def grade_type_points_or_weights
    @course.nil? ? "Points" : CourseService.grade_type_points_or_weights(@course).capitalize
  end
end
