require "spec_helper"


describe "Jobs" do

	context "When the user is on the new job page" do
   before do
	   visit('/')
	   @user = FactoryGirl.create(:faculty_frank)
	   login_with_oauth @user
	   click_link "Jobs"
	   click_link "Post a job"
   end


	  it "The job sponsors includes the current user" do
	  	find_field('supervisors[]').value.should eq 'Faculty Frank'
	  end

	  context "And the user fills in no fields" do
	  	before do
	  		click_button('Create Job')
	  	end

		  it "Then job is not created" do
		  	page.should have_content("Title can't be blank")
		  end
		end

	  context "And the user fills in required fields" do
	  	before do
	  		fill_in "Title", :with => "My awesome project"
	  		click_button('Create Job')
	  	end

		  it "Then job is created" do
		  	page.should have_content("Job was successfully created")
		  end
		end

# test the required field title

    
	end
end
