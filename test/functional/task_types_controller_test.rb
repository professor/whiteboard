require 'test_helper'

class TaskTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:task_types)
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


  def test_should_create_task_type_as_student
    login_as :student_sam
    assert_difference('TaskType.count', 0) do
      post :create, :task_type => { }
    end

    assert_response :redirect
  end

  def test_should_create_task_type_as_faculty
    login_as :faculty_frank
    assert_difference('TaskType.count') do
      post :create, :task_type => { }
    end

    assert_redirected_to task_type_path(assigns(:task_type))
  end


  def test_should_show_task_type
    login_as :student_sam
    get :show, :id => task_types(:one).id
    assert_response :success
  end

  def test_should_get_edit_as_student
    login_as :student_sam
    get :edit, :id => task_types(:one).id
    assert_response :redirect
  end

  def test_should_get_edit_as_faculty
    login_as :faculty_frank
    get :edit, :id => task_types(:one).id
    assert_response :success
  end


  def test_should_update_task_type_as_student
    login_as :student_sam
    put :update, :id => task_types(:one).id, :task_type => { }
    assert_response :redirect
  end

  def test_should_update_task_type_as_faculty
    login_as :faculty_frank
    put :update, :id => task_types(:one).id, :task_type => { }
    assert_redirected_to task_type_path(assigns(:task_type))
  end


  def test_should_destroy_task_type_as_student
    login_as :student_sam
    assert_difference('TaskType.count', 0) do
      delete :destroy, :id => task_types(:one).id
    end

    assert_response :redirect
  end

  def test_should_destroy_task_type_as_admin
    login_as :admin_andy
    assert_difference('TaskType.count', -1) do
      delete :destroy, :id => task_types(:one).id
    end

    assert_redirected_to task_types_path
  end


end
