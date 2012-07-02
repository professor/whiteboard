require 'spec_helper'

describe EffortReportsController do

  it "should have the correct url for the google charting api" # do
#    login(users(:student_sam))
#
#    foundations = FactoryGirl.create(:fse)
#    line1 = FactoryGirl.create(:effort1)
#    line2 = FactoryGirl.create(:effort2, :person => line1.person)
#    line3 = FactoryGirl.create(:effort3, :person => line1.person)
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

  before(:each) do
    login(FactoryGirl.create(:student_sam))
  end

  describe "#index" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "#show_week" do
    it "should be successful" do
      get :show_week
      response.should be_success
    end

    context "when the week is passed and is in last year" do
      before do
        get :show_week, :week => '-1'
      end

      specify { assigns(:week_number).should == 1 }
      specify { assigns(:next_week_number).should == 2 }
      specify { assigns(:prev_week_number).should == 0 }
    end

    context "when the week is passed and is in the middle of the year" do
      before do
        get :show_week, :week => '26'
      end

      specify { assigns(:week_number).should == 26 }
      specify { assigns(:next_week_number).should == 27 }
      specify { assigns(:prev_week_number).should == 25 }
    end

    context "when the week is passed and is in the next year" do
      before do
        get :show_week, :week => '53'
      end

      specify { assigns(:week_number).should == 1 }
      specify { assigns(:next_week_number).should == 2 }
      specify { assigns(:prev_week_number).should == 0 }
    end

    context "when the week is in the middle of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(26)
        get :show_week
      end

      specify { assigns(:week_number).should == 26 }
      specify { assigns(:next_week_number).should == 27 }
      specify { assigns(:prev_week_number).should == 25 }
    end
  end
end
