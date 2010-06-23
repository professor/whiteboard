require 'test_helper'

class CoursesControllerTest < ActionController::TestCase

  fixtures :course_numbers
  setup :activate_authlogic



  def test_should_get_index_without_user
    get :index
    assert_redirected_to login_google_url
  end


  def test_should_get_index_with_user
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  def test_should_get_new
    login_as :student_sam
#    get :new, {}, { :user_id => users(:student_sam).id }
    get :new
    assert_response :success
  end

  def test_should_create_course
    login_as :student_sam
    assert_difference('Course.count') do
      post :create, :course => { :course_number_id => course_numbers(:foundations).id }
    end

    assert_redirected_to course_path(assigns(:course))
  end

  def test_should_show_course
    login_as :student_sam
    get :show, :id => courses(:foundations).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :student_sam
    get :edit, :id => courses(:foundations).id
    assert_response :success
  end

  def test_should_update_course
    login_as :student_sam
    put :update, :id => courses(:foundations).id, :course => { }
    assert_redirected_to course_path(assigns(:course))
  end

  def test_should_destroy_course
    login_as :student_sam
    assert_difference('Course.count', -1) do
      delete :destroy, :id => courses(:foundations).id
    end

    assert_redirected_to courses_path
  end
end
