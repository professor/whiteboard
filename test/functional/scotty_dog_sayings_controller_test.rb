require 'test_helper'

class ScottyDogSayingsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:scotty_dog_sayings)
  end

  def test_should_get_new
    login_as :student_sam
    get :new
    assert_response :success
  end

  def test_should_create_scotty_dog_saying
    login_as :student_sam
    assert_difference('ScottyDogSaying.count') do
      post :create, :scotty_dog_saying => { :saying => "I'm in a test case", :user_id => "1" }
    end

    assert_redirected_to :action => "index"
  end

  def test_should_show_scotty_dog_saying
    login_as :student_sam
    get :show, :id => scotty_dog_sayings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :student_sam
    get :edit, :id => scotty_dog_sayings(:one).id
    assert_response :success
  end

  def test_should_update_scotty_dog_saying
    login_as :student_sam
    put :update, :id => scotty_dog_sayings(:one).id, :scotty_dog_saying => { }
    assert_redirected_to :action => "index"
  end

  def test_should_destroy_scotty_dog_saying
    login_as :student_sam
    assert_difference('ScottyDogSaying.count', -1) do
      delete :destroy, :id => scotty_dog_sayings(:one).id
    end

    assert_redirected_to scotty_dog_sayings_path
  end
end
