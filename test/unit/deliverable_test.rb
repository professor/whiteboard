require 'test_helper'

class DeliverableTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  test "is valid with valid attributes" do
    deliverable = deliverables(:teamDeliverable1)
    assert_valid deliverable
    current_revision = deliverable.current_attachment
    assert_not_nil current_revision
    assert_not_nil current_revision.submission_date
    assert_not_nil current_revision.submitter
    assert_not_nil current_revision.revision_file_name
    assert_valid current_revision
  end

  test "is not valid without a submission date" do
    deliverable = deliverables(:teamDeliverable1)
    revision = deliverable.current_attachment
    revision.submission_date = nil
    assert_nil revision.submission_date
    assert !revision.valid?
  end

  test "is not valid without an submitter" do
    deliverable = deliverables(:teamDeliverable1)
    revision = deliverable.current_attachment
    revision.submitter = nil
    assert !revision.valid?    
  end

  test "is not valid without a file attachment" do
    # This is handled by the controller, not the model.         
  end

end
