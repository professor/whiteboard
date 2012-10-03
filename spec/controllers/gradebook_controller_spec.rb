require 'spec_helper'

describe GradebookController do
    
    before(:all) do
      @user = FactoryGirl.create(:faculty_frank)  
      @course = FactoryGirl.create(:mfse)
    end
    
    it 'should have course name if course exists' do
      login(@user)
      current_user.id.should eq(@user.id)
    end

    it 'should have registered students'
    it 'should list students\' team name'

end
