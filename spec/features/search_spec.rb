require "spec_helper"

describe "Search" do
  context "When the user searches for" do
    before(:each) do
      visit '/'
      @user = FactoryGirl.create(:student_sam)
      login_with_oauth @user
      click_button('searchSubmit')
    end

    it "nothing - page should render" do
      current_path.should == search_index_path
    end

    it "valid string - page should show the results", :skip_on_build_machine => true do
      fill_in "query", :with => "Search String"
      click_button('searchSubmit')
      page.should have_content('Your search for "Search String" returned 0 results')
    end

    describe "invalid string" do
      it "like '-+_' - the page should not tank", :skip_on_build_machine => true do
        fill_in "query", :with => "-+_"
        click_button('searchSubmit')
        current_path.should == search_index_path
        page.should have_content('Search for: ')
      end
      it "like '-%20%3C/p%3E%20-' - the page should not tank", :skip_on_build_machine => true do
        fill_in "query", :with => "-%20%3C/p%3E%20-"
        click_button('searchSubmit')
        page.should have_content('Your search for "-%20%3C/p%3E%20-" returned 0 results')
      end
    end
  end
end
