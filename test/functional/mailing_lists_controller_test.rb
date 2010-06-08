require 'test_helper'

class MailingListsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
  end

# Todo: to test this, we would need to create a google group and then do a show, then clean it up
#  def test_should_show
#    login_as :student_sam
#    get :show, :id => scotty_dog_sayings(:one).id
#    assert_response :success
#  end
end
