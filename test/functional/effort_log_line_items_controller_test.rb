require 'test_helper'

class EffortLogLineItemsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:effort_log_line_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_effort_log_line_item
    assert_difference('EffortLogLineItem.count') do
      post :create, :effort_log_line_item => { }
    end

    assert_redirected_to effort_log_line_item_path(assigns(:effort_log_line_item))
  end

  def test_should_show_effort_log_line_item
    get :show, :id => effort_log_line_items(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => effort_log_line_items(:one).id
    assert_response :success
  end

  def test_should_update_effort_log_line_item
    put :update, :id => effort_log_line_items(:one).id, :effort_log_line_item => { }
    assert_redirected_to effort_log_line_item_path(assigns(:effort_log_line_item))
  end

  def test_should_destroy_effort_log_line_item
    assert_difference('EffortLogLineItem.count', -1) do
      delete :destroy, :id => effort_log_line_items(:one).id
    end

    assert_redirected_to effort_log_line_items_path
  end
end
