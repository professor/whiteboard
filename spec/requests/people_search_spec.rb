require 'spec_helper'

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

    # put AJAX test code here

    # I think this test is not needed anymore since '.data_card img' has implicitly required a ,data_card element to exist
    #before do
      #should have_selector '.data_card'
    #end

    it "Should display images with the search results" do
      should have_selector '.data_card img'
    end

  end

end