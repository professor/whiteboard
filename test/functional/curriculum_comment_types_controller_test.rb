require 'test_helper'

class CurriculumCommentTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:curriculum_comment_types)
  end

  def test_should_get_new_as_student
    login_as :student_sam
    get :new
    assert_response :redirect
  end

    def test_should_get_new_as_faculty
    login_as :faculty_frank
    get :new
    assert_response :success
  end


  def test_should_create_curriculum_comment_type_as_student
    login_as :student_sam
    assert_difference('CurriculumCommentType.count', 0) do
      post :create, :curriculum_comment_type => { }
    end
    assert_response :redirect
  end

    def test_should_create_curriculum_comment_type_as_faculty
    login_as :faculty_frank
    assert_difference('CurriculumCommentType.count') do
      post :create, :curriculum_comment_type => { }
    end

    assert_redirected_to curriculum_comment_type_path(assigns(:curriculum_comment_type))
  end


  def test_should_show_curriculum_comment_type
    login_as :student_sam
    get :show, :id => curriculum_comment_types(:one).id
    assert_response :success
  end

  def test_should_get_edit_as_student
    login_as :student_sam
    get :edit, :id => curriculum_comment_types(:one).id
    assert_response :redirect
  end

  def test_should_get_edit_as_faculty
    login_as :faculty_frank
    get :edit, :id => curriculum_comment_types(:one).id
    assert_response :success
  end

  def test_should_update_curriculum_comment_type_as_student
    login_as :student_sam
    put :update, :id => curriculum_comment_types(:one).id, :curriculum_comment_type => { }
    assert_response :redirect
  end

  def test_should_update_curriculum_comment_type_as_faculty
    login_as :faculty_frank
    put :update, :id => curriculum_comment_types(:one).id, :curriculum_comment_type => { }
    assert_redirected_to curriculum_comment_type_path(assigns(:curriculum_comment_type))
  end

  def test_should_destroy_curriculum_comment_type_as_student
    login_as :student_sam
    assert_difference('CurriculumCommentType.count', 0) do
      delete :destroy, :id => curriculum_comment_types(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_curriculum_comment_type_as_admin
    login_as :admin_andy
    assert_difference('CurriculumCommentType.count', -1) do
      delete :destroy, :id => curriculum_comment_types(:one).id
    end

    assert_redirected_to curriculum_comment_types_path
  end
end
