require "spec_helper"

describe "Pages" do

  context "with permission" do
    it "'world' : are visible to anyone" do
      @page = FactoryGirl.create(:page, :viewable_by => 'world')
      visit (page_path(@page))
      page.should have_content(@page.title)
      page.should have_content(@page.tab_one_contents)
    end

    context "'users' :" do
      before(:each) do
        @page = FactoryGirl.create(:page, :viewable_by => 'users')
      end
      it "are viewable by registered users" do
        @user = FactoryGirl.create(:student_sam)
        login_with_oauth @user
        visit (page_path(@page))
        page.should have_content(@page.title)
        page.should have_content(@page.tab_one_contents)
      end
      it "are not viewable by non-registerd users" do
        visit (page_path(@page))
        page.should have_content("You don't have permission to do this action.")
      end
    end
    xit "to staff only, if the page permission is 'staff'" do

    end
  end

end
