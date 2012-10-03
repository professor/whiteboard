require "spec_helper"

describe "people search" do

  before do
    visit('/')
    @user = FactoryGirl.create(:student_sam)
    login_with_oauth @user
    click_link "Users"
  end

  it "Should have no results at the beginning" do
    page.should have_selector('#results_box')
    page.should_not have_selector('#results_box .data_card')
  end

  context 'with search results' do

    before do
      fill_in "qText" , :with => "Sam"
      click_button "submit_btn"
    end

    it "Should display images with the search results", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card img')
    end

  end

end