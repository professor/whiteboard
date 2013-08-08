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
        visit ('/')
        @user = FactoryGirl.create(:student_sam)
        login_with_oauth @user

        visit (page_path(@page))
#        save_and_open_page
        page.should have_content(@page.title)
        page.should have_content(@page.tab_one_contents)
      end
      it "are not viewable by non-registered users" do
        visit "/logout"
        visit (page_path(@page))
        page.should have_content("You don't have permission to do this action.")
      end
    end

    context "'staff' :" do
      before(:each) do
        @page = FactoryGirl.create(:page, :viewable_by => 'staff')
      end
      it "are viewable by staff and faculty" do
        visit ('/')
        @faculty_fagan = FactoryGirl.create(:faculty_fagan)
        login_with_oauth @faculty_fagan

        visit (page_path(@page))
        page.should have_content(@page.title)
        page.should have_content(@page.tab_one_contents)
      end
      it "are not viewable by all registered users" do
        visit ('/')
        @user = FactoryGirl.create(:student_sam)
        login_with_oauth @user
        visit (page_path(@page))
        page.should have_content("You don't have permission to do this action.")
      end
      it "are not viewable by public users" do
        visit "/logout"
        visit (page_path(@page))
        page.should have_content("You don't have permission to do this action.")
      end
    end
  end
end
