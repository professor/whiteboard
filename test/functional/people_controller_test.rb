require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  def test_should_get_index_without_login
    login_as nil
    get :index
    assert_response :redirect
  end

  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  def test_should_get_phone_book
    login_as :student_sam
    get :phone_book
    assert_response :success
    assert_not_nil assigns(:people)
  end


  def test_should_get_new_as_student
    login_as :student_sam
    get :new
    assert_response 302
  end

  def test_should_get_new_as_admin
    login_as :admin_andy
    get :new
    assert_response :success
  end


  def test_should_create_person_as_student
    login_as :student_sam
    assert_difference('Person.count', 0) do
      post :create, :person => { :first_name => "New", :last_name => "Person"}
    end

    assert_redirected_to people_path()
  end

  def test_should_create_person_as_admin
    login_as :admin_andy
    assert_difference('Person.count', 1) do
      post :create, :person => { :first_name => "New", :last_name => "Person", :email => "New.Person@sv.cmu.edu"}
    end

    assert_redirected_to person_path(assigns(:person))
  end


  def test_should_create_person_and_google_email
    login_as :faculty_frank

#    google_user = google_apps_connection.retrieve_user(google_username)

    assert_difference('Person.count') do
        post :create, { :person => { :first_name => "New", :last_name => "Person", :email => "New.Person@sv.cmu.edu"}, :create_google_email => "1", :create_twiki_account => nil}
    end
#    google_user = google_apps_connection.retrieve_user(google_username)

    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_show_person
    login_as :student_sam
    get :show, :id => users(:student_sam).id
    assert_response :success
  end

  def test_should_show_person_without_login
    login_as nil
    get :show, :id => users(:student_sam).id
    assert_response :redirect
  end


  def test_should_get_edit
    login_as :student_sam
    get :edit, :id => users(:student_sam).id
    assert_response :success
  end

  def test_should_update_person
    login_as :student_sam
    put :update, :id => users(:student_sam).id, :person => { }
    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_destroy_person_as_student
    login_as :student_sam
    assert_difference('Person.count', 0) do
      delete :destroy, :id => users(:student_sam).id
    end

    assert_response :redirect
  end

  def test_should_destroy_person_as_admin
    login_as :admin_andy
    assert_difference('Person.count', -1) do
      delete :destroy, :id => users(:student_sam).id
    end

    assert_redirected_to people_path
  end

  def test_should_get_my_teams_as_student
    login_as :student_sam
    get :my_teams, :id => users(:student_sam).id
    assert_response :success
  end

  def test_should_get_my_faculty_teams_as_faculty
    login_as :faculty_frank
    get :my_teams, :id => users(:faculty_frank).id
    assert_response :success
  end


  def test_should_retreive_people_by_ajax
#    http://localhost:3000/people.js?search=todd
# <ul><li>Todd Sedano</li></ul>

#renable bug by putting the format back in.    
  end

end
