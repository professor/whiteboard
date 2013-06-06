require "rspec"
  require "spec_helper"

  describe "PeopleSearch" do

    subject {page}

    describe 'on mobile device', mobile: true do

      before do
        visit root_path(mobile:1)
        @user = FactoryGirl.create(:student_sam)
        login_with_oauth @user
        click_link "People"
      end

      it 'should have people search div' do
        subject.should have_selector('div#people_search')
      end

      it "should not display navigation bar" do
        get '/people', {}, {"HTTP_USER_AGENT" => 'Mobile'}
        response.should_not have_selector('div#navWrapper')
      end



    end

  end