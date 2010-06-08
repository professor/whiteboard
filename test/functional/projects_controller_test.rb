require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
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


  def test_should_create_project_as_student
    login_as :student_sam
    assert_difference('Project.count', 0) do
      post :create, :project => { }
    end

    assert_response :redirect
  end

 def test_should_create_project_as_faculty
    login_as :faculty_frank
    assert_difference('Project.count') do
      post :create, :project => { }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_show_project
    login_as :student_sam
    get :show, :id => projects(:one).id
    assert_response :success
  end

  def test_should_get_edit_as_student
    login_as :student_sam
    get :edit, :id => projects(:one).id
    assert_response :redirect
  end

  def test_should_get_edit_as_faculty
    login_as :faculty_frank
    get :edit, :id => projects(:one).id
    assert_response :success
  end


  def test_should_update_project_as_student
    login_as :student_sam
    put :update, :id => projects(:one).id, :project => { }
    assert_response :redirect
  end

   def test_should_update_project_as_faculty
    login_as :faculty_frank
    put :update, :id => projects(:one).id, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_destroy_project_as_student
    login_as :student_sam
    assert_difference('Project.count', 0) do
      delete :destroy, :id => projects(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_project_as_admin
    login_as :admin_andy
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:one).id
    end

    assert_redirected_to projects_path
  end

end
