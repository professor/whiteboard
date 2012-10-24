require "rspec"
  require "spec_helper"

  describe "PeopleSearch" do

    before do
      @user = FactoryGirl.create(:student_sam)
      login_with_oauth(@user)
      #@user.program = "SE"
      #@user.program
    end

    it "renders phone book page" do
      visit("/people_search?filterBoxOne=Student")
      rendered.should have_content("#{@user.first_name}")
      rendered.should have_content("#{@user.last_name}")
      rendered.should have_content("#{@user.email}")
    end

  end