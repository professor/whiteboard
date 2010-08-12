require 'test_helper'

class EffortReportsControllerTest < ActionController::TestCase


  def test_campus_semester_as_student
    login_as :student_sam
    get :campus_semester
    assert_response :success

    #assert that the number of entries in the student drop down is two or less

  end

  def test_should_get_index_without_login
    login_as nil
    get :index
    assert_redirected_to login_google_url
  end
#

end
