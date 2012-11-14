module DeliverablesHelper
  def display_maximum_score
    return @deliverable.assignment.maximum_score
  end
end
