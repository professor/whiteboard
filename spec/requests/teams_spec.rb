require "spec_helper"

describe "teams" do

   before do
   visit('/')
   @team = FactoryGirl.create(:team_triumphant)
   @user = @team.members[0]
   login_with_oauth @user
   click_link "My Teams"
   end

  context "my teams" do

    it "renders my teams" do
      page.should have_content("My Teams")
      page.should have_content("#{@user.human_name}")

      if @user.is_student?
         page.should have_content("is a team member")
      end

      if @user.is_staff?
         page.should have_content("is teaching the course")
      end
    end

    it "shows correct teams" do
      Team.any_instance.stub(:show_addresses_for_mailing_list).and_return(["email"])
      page.should have_link("#{@team.name}")
      page.should have_link("Show")
      click_link "Show"
      page.should have_content("Name: " "#{@team.name}")
    end

  end


end