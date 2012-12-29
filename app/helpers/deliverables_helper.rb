module DeliverablesHelper
  def display_maximum_score
   grading_type= GradingRule.get_grade_type(@course.id)



   case grading_type
     when "letter"
       val="A"
       return val
     when "points"
       return @deliverable.assignment.maximum_score
     when "weights"
       val= "100%"
       return val
     end
   end




end
