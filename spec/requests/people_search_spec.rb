require 'spec_helper'

describe "Initial_Search_Page" do

  before do
    visit('/')
    @user = FactoryGirl.create(:student_sam)
    login_with_oauth @user
    click_link "Users"
  end

  it "Should be a blank page" do
    should_not have_selector '.data_card'
  end

  context 'with results' do
    before do
      should have_selector '.data_card'
    end

    it "Should display images with the search results" do
      should have_selector '.data_card img'
    end
  end

end