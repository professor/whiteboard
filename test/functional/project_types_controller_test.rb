require 'test_helper'

class ProjectTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:project_types)
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

  def test_should_create_project_type_as_student
    login_as :student_sam
    assert_difference('ProjectType.count', 0) do
      post :create, :project_type => { }
    end

    assert_response :redirect
  end

  def test_should_create_project_type_as_faculty
    login_as :faculty_frank
    assert_difference('ProjectType.count') do
      post :create, :project_type => { }
    end

    assert_redirected_to project_type_path(assigns(:project_type))
  end

  def test_should_show_project_type
    login_as :student_sam
    get :show, :id => project_types(:one).id
    assert_response :success
  end

  def test_should_get_edit_as_student
    login_as :student_sam
    get :edit, :id => project_types(:one).id
    assert_response :redirect
  end

    def test_should_get_edit_as_faculty
    login_as :faculty_frank
    get :edit, :id => project_types(:one).id
    assert_response :success
  end


  def test_should_update_project_type_as_student
    login_as :student_sam
    put :update, :id => project_types(:one).id, :project_type => { }
    assert_response :redirect
  end

  def test_should_update_project_type_as_faculty
    login_as :faculty_frank
    put :update, :id => project_types(:one).id, :project_type => { }
    assert_redirected_to project_type_path(assigns(:project_type))
  end


  def test_should_destroy_project_type_as_student
    login_as :student_sam
    assert_difference('ProjectType.count', 0) do
      delete :destroy, :id => project_types(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_project_type_as_admin
    login_as :admin_andy
    assert_difference('ProjectType.count', -1) do
      delete :destroy, :id => project_types(:one).id
    end

    assert_redirected_to project_types_path
  end

end
