require "spec_helper"

describe "gradebooks" do

  before do
    visit('/')
    @team = FactoryGirl.create(:team_triumphant)
    @user = @team.members[0]
    login_with_oauth @user
    click_link "My Gradebooks"
  end

  context "my gradebooks" do
    it "renders my gradebooks" do
      page.should have_selector("h1", text: "My Gradebooks")
    end
  end
end