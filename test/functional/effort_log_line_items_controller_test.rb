require 'test_helper'

class EffortLogLineItemsControllerTest < ActionController::TestCase
  
  def test_should_redirect_to_effort_log_index
    get :index
    assert_redirected_to :controller => :effort_logs, :action => :index
    get :new
    assert_redirected_to :controller => :effort_logs, :action => :index
    get :show, :id => effort_log_line_items(:one).id
    assert_redirected_to :controller => :effort_logs, :action => :index
    get :edit, :id => effort_log_line_items(:one).id
    assert_redirected_to :controller => :effort_logs, :action => :index
    put :update, :id => effort_log_line_items(:one).id, :effort_log_line_item => { }
    assert_redirected_to :controller => :effort_logs, :action => :index
    assert_difference('EffortLogLineItem.count', 0) do
      delete :destroy, :id => effort_log_line_items(:one).id
      assert_redirected_to :controller => :effort_logs, :action => :index
    end
  end
  
end
