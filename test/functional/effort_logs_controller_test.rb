require 'test_helper'

class EffortLogsControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :student_sam
    get :index
    assert_response :success
    assert_not_nil assigns(:effort_logs)
  end

  def test_should_get_new
    login_as :student_sam
    get :new
    assert_response :redirect
#    assert_redirected_to :action => 'edit'
  end

  def test_should_create_effort_log
    login_as :student_sam
    assert_difference('EffortLog.count') do
      post :create, :effort_log => { :year => "2009", :week_number => "3", :person_id => users(:student_sam).id }
    end

    assert_redirected_to effort_log_path(assigns(:effort_log))
  end

  def test_should_show_effort_log
    login_as :student_sam
    get :show, :id => effort_logs(:week_one).id
    assert_response :success
  end

  def test_should_get_edit_previous
    login_as :student_sam
    get :edit, :id => effort_logs(:week_one).id
    assert_response :redirect
  end

  def test_should_get_edit_current
    login_as :student_sam
    get :edit, :id => effort_logs(:this_week).id
    assert_response :success
  end

  def test_should_update_old_effort_log_as_student
    login_as :student_sam
    put :update, :id => effort_logs(:week_one).id, :effort_log => { }
    assert_response :redirect
  end

  def test_should_update_old_effort_log_as_admin
    login_as :admin_andy
    put :update, :id => effort_logs(:week_one).id, :effort_log => { }
    assert_redirected_to edit_effort_log_path(assigns(:effort_log))
  end


  def test_should_destroy_effort_log
    login_as :student_sam
    assert_difference('EffortLog.count', -1) do
      delete :destroy, :id => effort_logs(:this_week).id
    end

    assert_redirected_to effort_logs_path
  end

  def test_index_show_prior_week_true
    login_as :student_sam
    now_as(Time.local(2009,"nov",02)) do
      assert_equal(Date.today, Date.new(2009,11,02))
      assert Date.today.cwday == 1 # assert that 2009-11-02 is a Monday
      get :index
      assert_response :success
      assert_not_nil assigns(:show_prior_week)
      assert assigns(:show_prior_week)
    end
  end

  def test_index_show_prior_week_false
    login_as :student_sam
    now_as(Time.local(2009,"oct",28)) do
      assert_equal(Date.today, Date.new(2009,10,28))
      assert Date.today.cwday == 3 # assert that 2009-10-28 is a Wednesday
      get :index
      assert_response :success
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)
    end
  end

# Failed test cases by Student 
#  #Student entering the effort for the assigned courses
#  def test_log_effort_for_assigned_courses
#    login_as :student_sam
#    @person = Person.find_by_id(users(:student_sam).id)
#    #pick a unique week, verify that there is no effort logged for this user on that week
#    @effort_log = EffortLog.find(:first, :conditions => {:person_id => @person.id, :week_number => Date.today.cweek, :year => Date.today.year})
#    #create an effort log entry for this week log hours on several days of that week for foundations
#    @effort_log = EffortLog.new(:person_id => @person.id, :week_number => Date.today.cweek, :year => Date.today.year)
#    @effort_log.save
#    @course = courses(:foundations)
#    @effort_log_line_item = EffortLogLineItem.new(:effort_log_id => @effort_log.id, :course_id=>@course.id, :day1=>5, :day2=>7, :day5=>4)
#    @effort_log_line_item.save
#
##    get :create
#
#
#    post :update, :id => @effort_log.id,
##      :effort_log => {:person_id => @person.id,:week_number => Date.today.cweek, :year => Date.today.year,
#       :effort_log => {
#        :existing_effort_log_line_item_attributes => { @effort_log_line_item.id => {:day1 => "4", :day2=>"", :day3=>""}}}
#    assert_redirected_to :action => "edit"
#    assert_equal("EffortLog was successfully updated.", flash[:notice])
#    #check to see if there is no error message
#    #assert_equal(0, @effort_log_line_item.errors.size)
#  end
#
#
#  #Student entering effort against unregistered courses
#  def test_log_effort_for_not_assigned_courses
#    login_as :student_sam
#    @person = Person.find_by_id(users(:student_sam).id)
#
#    #pick a unique week  verify that there is no effort logged for this user on that week
#    @effort_log = EffortLog.find(:first, :conditions => {:person_id => @person.id, :week_number => Date.today.cweek, :year => Date.today.year})
#    #create an effort log entry for this week and log hours on several days of that week for mfse
#    @effort_log = EffortLog.new(:person_id => @person.id, :week_number => Date.today.cweek, :year => Date.today.year)
#    @effort_log.save
#    @course = courses(:mfse)
#    @effort_log_line_item = EffortLogLineItem.new(:effort_log_id => @effort_log.id, :course_id=>@course.id, :day1=>5, :day2=>7, :day5=>4)
#    @effort_log_line_item.save
##    post :update, :id => @effort_log.id,
##      :effort_log => {:person_id => @person.id,:week_number => Date.today.cweek, :year => Date.today.year,
##      :existing_effort_log_line_item_attributes => [@effort_log_line_item]}
#    post :update, :id => @effort_log.id,
#       :effort_log => {
#        :existing_effort_log_line_item_attributes => { @effort_log_line_item.id => {:day1 => "4", :day2=>"", :day3=>""}}}
#    assert_redirected_to :action => "index"
#    assert_equal("You are unable to update effort logs from the past.", flash[:error])
#  end




def test_index_show_two_weeks_when_no_entries_on_monday
    login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # use Monday
  now_as(Time.local(2009,"nov",02)) do
      get :index
      assert_response :success

      # test for prior week link
      assert_not_nil assigns(:show_prior_week)
      assert assigns(:show_prior_week)

      # test for current week link
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end
end

def test_index_show_two_weeks_when_no_entries_on_monday_and_first_week_of_year
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # use Monday
  now_as(Time.local(2008,"dec",29)) do
      get :index
      assert_response :success

      # test for prior week link
      assert_not_nil assigns(:show_prior_week)
      assert assigns(:show_prior_week)

      # test for current week link
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end
end

def test_index_show_current_week_on_monday_and_first_week_of_year_with_entry_for_prior_week
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the first week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 1, :year => 2009 }
  end

  # now test that the prior week appears but the current link doesn't on the first Monday of the commercial year
  now_as(Time.local(2008,"dec",29)) do
      get :index
      assert_response :success

      # test for prior week link
      assert_not_nil assigns(:show_prior_week)
      assert assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert !assigns(:show_new_link)
    end
end


def test_index_shows_nothing_on_year_boundary_when_both_entries_exist
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the first week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 1, :year => 2009 }
  end
  # add an entry for the last week of the year
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 52, :year => 2008 }
  end

  # now test that no links appear
  now_as(Time.local(2008,"dec",29)) do
      get :index
      assert_response :success

      # test for absence of prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert !assigns(:show_new_link)
    end
end

def test_index_shows_current_week_on_year_boundary_when_prior_entry_exists
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the last week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 52, :year => 2008 }
  end

  # now test that current appears and prior does not appear
  now_as(Time.local(2008,"dec",29)) do
      get :index
      assert_response :success

      # test for absence of prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end
end

def test_index_only_shows_current_week_on_monday_with_entry_for_prior_week
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the first week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 44, :year => 2009 }
  end

  # now test that the prior week appears but the current link doesn't on the first Monday of the commercial year
  now_as(Time.local(2009,"nov",2)) do
      get :index
      assert_response :success

      # test for prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end
end

def test_index_only_shows_prior_week_on_monday_with_entry_for_current_week
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the first week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 45, :year => 2009 }
  end

  # now test that the prior week appears but the current link doesn't on the first Monday of the commercial year
  now_as(Time.local(2009,"nov",2)) do
      get :index
      assert_response :success

      # test for prior week link
      assert_not_nil assigns(:show_prior_week)
      assert assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert !assigns(:show_new_link)
    end
end

def test_index_show_one_week_when_no_entries_and_not_monday
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # use Sunday
  now_as(Time.local(2009,"nov",01)) do
      get :index
      assert_response :success

      # test for absence of prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for current week link
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end

  # use Tuesday
  now_as(Time.local(2009,"nov",03)) do
      get :index
      assert_response :success

      # test for absense of prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for current week link
      assert_not_nil assigns(:show_new_link)
      assert assigns(:show_new_link)
    end
end

def test_index_shows_nothing_when_both_entries_exist
  login_as :student_sam
  # delete all records in EffortLogs table from DB
  EffortLog.delete_all
  assert_equal(EffortLog.count, 0)

  # now that all of the fixtures are gone, add an entry for the first week of the year
  @person = Person.find_by_id(users(:student_sam).id)
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 44, :year => 2009 }
  end
  # add an entry for the last week of the year
  assert_difference('EffortLog.count') do
    post :create, :effort_log => { :person => @person, :week_number => 45, :year => 2009 }
  end

  # now test that no links appear
  now_as(Time.local(2009,"nov",2)) do
      get :index
      assert_response :success

      # test for absence of prior week link
      assert_not_nil assigns(:show_prior_week)
      assert !assigns(:show_prior_week)

      # test for absence of current week link, it exists in the fixtures
      assert_not_nil assigns(:show_new_link)
      assert !assigns(:show_new_link)
    end
end

def test_should_create_prior_effort_log_with_new
    login_as :student_sam
    assert_difference('EffortLog.count') do
      get :new, :prior => 'true'
    end
  end

def test_should_not_create_current_effort_log_with_new
    login_as :student_sam
    assert_no_difference('EffortLog.count') do
      # this call to new should not insert a new record because current week is added by the fixtures
      get :new, :prior => 'false'
    end
  end

  def test_should_not_create_prior_effort_log_twice
    login_as :student_sam
    assert_difference('EffortLog.count') do
      get :new, :prior => 'true'
    end
    assert_difference('EffortLog.count',0) do
      get :new, :prior => 'true'
    end
  end
end
