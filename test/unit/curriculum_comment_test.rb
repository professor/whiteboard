require 'test_helper'

class CurriculumCommentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end


  def test_notify_instructors
    comment = CurriculumComment.new
    comment.url = "https://curriculum.sv.cmu.edu/architecture_se/task08/requirements.shtml"
    comment.semester = "Summer"
    comment.year = "2009"
    assert_equal ["Todd.Sedano@sv.cmu.edu", "Reed.Letsinger@sv.cmu.edu", "Ed.Katz@sv.cmu.edu"], comment.notify_instructors

    comment.url = "https://curriculum.sv.cmu.edu/mfse/task1/requirements.shtml"
    assert_equal ["Martin.Radley@sv.cmu.edu"], comment.notify_instructors

    comment.url = "https://curriculum.sv.cmu.edu/esm/task1/requirements.shtml"
    assert_equal ["Gladys.Mercier@sv.cmu.edu", "Patricia.Collins@sv.cmu.edu"], comment.notify_instructors

  end

end
