require 'spec_helper'

module AjaxWaiter
  def wait_for_ajax
    wait_until { page.evaluate_script("jQuery.active") == 0 }
  end
end

describe "Initial_Search_Page" do

  before do
    visit('/')
    @user = FactoryGirl.create(:student_sam)
    login_with_oauth @user
    click_link "Users"
  end

  it "Should have no results at the beginning" do
    should_not have_selector '.data_card'
  end

  context 'with results' do

    # I think this test is not needed anymore since '.data_card img' has implicitly required a ,data_card element to exist
    before do
      fill_in "qText" , :with => "Sam"
      click_button "submit_btn"
      #wait_until { page.evaluate_script("jQuery.active") == 0 }
    end

    it "Should display images with the search results" do
      #wait_until(30) do
        should have_selector '.data_card img'
      #end
    end

  end

end