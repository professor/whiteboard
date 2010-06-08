require 'test_helper'

class PapersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_paper
    assert_difference('Paper.count') do
      post :create, :paper => { :title => "This is a sample paper"}
    end

#    assert_redirected_to paper_path(assigns(:paper))
  end

  def test_should_show_paper
    get :show, :id => papers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => papers(:one).id
    assert_response :success
  end

  def test_should_update_paper
    put :update, :id => papers(:one).id, :paper => { :title => "This is another paper" }
#    assert_redirected_to paper_path(assigns(:paper))
  end

  def test_should_destroy_paper
    assert_difference('Paper.count', -1) do
      delete :destroy, :id => papers(:one).id
    end

    assert_redirected_to papers_path
  end
end
