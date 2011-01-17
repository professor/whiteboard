require 'spec_helper'


describe ApplicationController do


  it 'should determine which Semester Mini it is' do
    Date.stub!(:today).and_return(Date.new(2011, 1, 10))
    ApplicationController.current_mini.should == "A"
    
    Date.stub!(:today).and_return(Date.new(2011, 3, 14))
    ApplicationController.current_mini.should == "B"

    Date.stub!(:today).and_return(Date.new(2011, 5, 16))
    ApplicationController.current_mini.should == "A"

    Date.stub!(:today).and_return(Date.new(2011, 6, 27))
    ApplicationController.current_mini.should == "B"

    Date.stub!(:today).and_return(Date.new(2011, 8, 29))
    ApplicationController.current_mini.should == "A"

    Date.stub!(:today).and_return(Date.new(2011, 10, 17))
    ApplicationController.current_mini.should == "B"
  end


end