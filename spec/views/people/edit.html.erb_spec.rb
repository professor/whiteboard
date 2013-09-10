require 'spec_helper'

describe "people/edit.html.erb" do

  describe "Login as a normal user" do
    before(:each) do
      person = FactoryGirl.create(:student_sam)
      login(person)
      @person = assign(:person, person)
    end

    it "renders the edit page form" do
      render
      rendered.should have_selector("form", :action => person_path(@person), :method => "post")
      rendered.should have_selector("#photo-first .use-this-photo")
      rendered.should have_selector("#photo-second .use-this-photo")
      rendered.should have_selector("#photo-custom .use-this-photo")
      rendered.should have_selector("#photo-anonymous .use-this-photo")
    end

    it "Has the option to upload the custom photo" do
      render
      rendered.should have_selector("#photo-custom .upload-new-photo")
    end

    it "Has no option to upload the first photo and second photo" do
      render
      rendered.should_not have_selector("#photo-first .upload-new-photo")
      rendered.should_not have_selector("#photo-second .upload-new-photo")
    end
  end
  
  describe "Login as a admin user" do
    before(:each) do
      person = FactoryGirl.create(:admin_andy)
      login(person)
      @person = assign(:person, person)
    end

    it "Has the option to upload the custom photo" do
      render
      rendered.should have_selector("#photo-custom .upload-new-photo")
    end

    it "Has options to upload the first photo and second photo" do
      render
      rendered.should have_selector("#photo-first .upload-new-photo")
      rendered.should have_selector("#photo-second .upload-new-photo")
    end
  end


end
