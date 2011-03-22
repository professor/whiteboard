require 'test_helper'

class CurriculumCommentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:curriculum_comments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_curriculum_comment
    assert_difference('CurriculumComment.count') do
      post :create, :curriculum_comment => { :comment => "This is a very useful feature.", :url => "http://rails.sv.cmu.edu"}
    end

    assert_redirected_to "http://rails.sv.cmu.edu"
  end

  def test_should_show_curriculum_comment
    login_as :student_sam
    get :show, :id => curriculum_comments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :student_sam
    get :edit, :id => curriculum_comments(:one).id
    assert_response :success
  end

  def test_should_update_curriculum_comment
    login_as :student_sam
    put :update, :id => curriculum_comments(:one).id, :curriculum_comment => { :comment => "This comment has been updated.", :url => "http://sv.cmu.edu" }
    assert_redirected_to curriculum_comments(:one).url
  end

  def test_should_destroy_curriculum_comment_as_student
    login_as :student_sam
    assert_difference('CurriculumComment.count', 0) do
      delete :destroy, :id => curriculum_comments(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_curriculum_comment_as_admin
    login_as :admin_andy
    assert_difference('CurriculumComment.count', -1) do
      delete :destroy, :id => curriculum_comments(:one).id
    end

    assert_redirected_to curriculum_comments_path
  end
end
