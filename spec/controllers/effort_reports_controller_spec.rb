require 'spec_helper'

describe EffortReportsController do
  fixtures :users

  it "should have the correct url for the google charting api" # do
#    login(users(:student_sam))
#
#    foundations = Factory(:fse)
#    line1 = Factory(:effort1)
#    line2 = Factory(:effort2, :person => line1.person)
#    line3 = Factory(:effort3, :person => line1.person)
#
#    get :campus_week
#    assert_response :success
#    url = assigns(:chart_url)
#
#
#    line_items = [line1.sum, line2.sum, line3.sum].sort
#
#    minimum, lower25, median, upper25, maximum = getvals(line_items)
#    course_dimensions =
#            "chd=t0:-1,#{"%.02f"%minimum},-1|-1,#{"%.02f"%lower25},-1|-1,#{"%.02f"%upper25},-1|-1,#{"%.02f"%maximum},-1|-1,#{"%.02f"%median},-1"
#    assert_match course_dimensions, url, "Course name should be correct"
#  end

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
