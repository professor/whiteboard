require 'test_helper'

class EffortReportsControllerTest < ActionController::TestCase


  def test_campus_semester_as_student
    login_as :student_sam
    get :campus_semester
    assert_response :success

    #assert that the number of entries in the student drop down is two or less

  end

  def test_should_get_index_without_login
    login_as nil
    get :index
    assert_redirected_to login_google_url
  end

  def test_campus_week_url
    login_as :student_sam
    get :campus_week
    assert_response :success
    assert_not_nil assigns(:chart_url)
    url = assigns(:chart_url)    

    title = "chtt=Campus View - Week #{(Date.today-7).cweek} of #{(Date.today-7).year}".gsub(/ /,"+")
    assert_match title, url, "Title should match"
    course_title = "chl=|#{effort_log_line_items(:three).course.name}|"
    assert_match course_title, url, "Course name should be correct"


  end

  def test_campus_week_url_accuracy_even_set
    login_as :student_sam
    get :campus_week
    assert_response :success
    url = assigns(:chart_url)


    line_items = [effort_log_line_items(:three).sum, effort_log_line_items(:four).sum].sort

    minimum, lower25, median, upper25, maximum = getvals(line_items)
    course_dimensions =
            "chd=t0:-1,#{"%.02f"%minimum},-1|-1,#{"%.02f"%lower25},-1|-1,#{"%.02f"%upper25},-1|-1,#{"%.02f"%maximum},-1|-1,#{"%.02f"%median},-1"
    assert_match course_dimensions, url, "Course name should be correct"
  end

  def test_campus_week_url_accuracy_odd_set
    login_as :student_sam

    EffortLogLineItem.create(:effort_log_id => 62, :course_id => 1,:task_type_id => 1,:day1 => 2,:day2 => 2,:day3 => 2,:day4 => 2,:day5 => 2,:day6 => 1,:day7 => 1,:sum => 24)

    get :campus_week
    assert_response :success
    url = assigns(:chart_url)

    line_items = [effort_log_line_items(:three).sum, effort_log_line_items(:four).sum, 24].sort

    minimum, lower25, median, upper25, maximum = getvals(line_items)
    course_dimensions =
            "chd=t0:-1,#{"%.02f"%minimum},-1|-1,#{"%.02f"%lower25},-1|-1,#{"%.02f"%upper25},-1|-1,#{"%.02f"%maximum},-1|-1,#{"%.02f"%median},-1"
    assert_match course_dimensions, url, "Course name should be correct"
  end

  def test_campus_semester_url_accuracy_even_set
    login_as :student_sam
    get :campus_semester
    assert_response :success
    url = assigns(:chart_url)


    line_items = [effort_log_line_items(:three).sum, effort_log_line_items(:four).sum].sort

    minimum, lower25, median, upper25, maximum = getvals(line_items)
    course_dimensions =
            "chd=t0:-1,#{"%.02f"%minimum},-1|-1,#{"%.02f"%lower25},-1|-1,#{"%.02f"%upper25},-1|-1,#{"%.02f"%maximum},-1|-1,#{"%.02f"%median},-1"
    assert_match course_dimensions, url, "Course name should be correct"
  end

  def getvals(ary)
    maximum = ary.max
    minimum = ary.min
    median = median(ary)
    if ary.count % 2 == 1
      lower25 = median(ary[0..((ary.count / 2).ceil)], 0.25)
      upper25 = median(ary[((ary.count / 2).floor)..-1], 0.75)
    else
      lower25 = median(ary[0...(1 + ary.count / 2)], 0.25)
      upper25 = median(ary[(-1 + ary.count / 2)..-1], 0.75)
    end

    minimum *= 100.0 / maximum
    median  *= 100.0 / maximum
    lower25 *= 100.0 / maximum
    upper25 *= 100.0 / maximum
    maximum = 100.0

    [minimum, lower25, median, upper25, maximum]
  end

  def median(ary, pct = 0.5)
    middle = (ary.count + 1)/2.0
    middle -= 1 # convert from set index to array index (count from 0)
    if ary.nil? or ary.count == 0
      nil    
    elsif ary.count == 1
      ary[0]
    elsif ary.count % 2 == 1
      ary[middle.floor]
    else
      ary[middle.floor] + (pct * (ary[middle.ceil] - ary[middle.floor]))
    end
  end


end
