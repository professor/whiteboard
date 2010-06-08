require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  fixtures :course_numbers
  fixtures :courses

  def test_should_get_index_for_one_course
    login_as :student_sam
    get :twiki_index, :course_id => teams(:one).course.id
    assert_response :success
#    assert_not_nil assigns(:teams)
  end

  def test_should_get_photo_index_for_one_course
    login_as :student_sam
    get :index_photos, :course_id => teams(:one).course.id
    assert_response :success
  end

  def test_should_get_index_for_all_teams
    login_as :student_sam
    get :index_all
    assert_response :success
  end


  def test_should_get_new
    login_as :student_sam
    get :new, :course_id => teams(:one).course.id
    assert_response :success
  end

  def test_should_create_team
    login_as :student_sam
    assert_difference('Team.count') do
      post :create, :course_id => teams(:one).course.id, :team => { }
    end

    assert_redirected_to course_teams_path(teams(:one).course)
  end

  def test_should_show_team
    login_as :student_sam
    get :show, :course_id => teams(:one).course.id, :id => teams(:one).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :student_sam
    get :edit, :course_id => teams(:one).course.id, :id => teams(:one).id
    assert_response :success
  end

  def test_should_update_team
    login_as :student_sam
    put :update, :course_id => teams(:one).course.id, :id => teams(:one).id, :team => { }
    assert_redirected_to course_teams_path(teams(:one).course)
  end

  def test_should_destroy_team_as_student
    login_as :student_sam
    assert_difference('Team.count', 0) do
      delete :destroy, :id => teams(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_team_as_admin
    login_as :admin_andy
    course = teams(:one).course
    assert_difference('Team.count', -1) do
      delete :destroy, :id => teams(:one).id
    end

    assert_redirected_to(course_teams_path(course))
  end
end
