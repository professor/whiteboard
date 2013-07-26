require "spec_helper"


describe "Jobs" do

  context "When the user is on the new job page" do
    before do
      visit '/'
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
  end

  context "When the user is on the job list page" do
    before do
     @job = FactoryGirl.create(:job, :funding_description => "Major Funding from Major Corp.")
     visit '/'
    end

    it "The funding details should only be visible to staff" do
      @user = FactoryGirl.create(:faculty_frank_user)
      login_with_oauth @user

      click_link "Jobs"
      page.should have_content("Major Funding from Major Corp.")
    end

    it "The funding details should not be visible to students" do
      @student_sam = FactoryGirl.create(:student_sam_user)
      login_with_oauth @student_sam

      click_link "Jobs"
      page.should have_no_content("Major Funding from Major Corp.")
    end

    context 'supervisor' do
      it "can edit a job they posted" do
        @faculty_frank_user = FactoryGirl.create(:faculty_frank_user)
        @job.supervisors << @faculty_frank_user
        @job.save

        login_with_oauth @faculty_frank_user
        click_link "Jobs"

        page.should have_link('Edit', :href => edit_job_path(@job))
      end

      it "cannot edit a job they didn't post" do
        visit "/logout"
        visit '/'
        @faculty_fagan_user = FactoryGirl.create(:faculty_fagan_user)

        login_with_oauth @faculty_fagan_user
        click_link "Jobs"

        visit edit_job_path(@job)
        page.should have_content("You don't have permission to update job.")
      end
    end
  end

  context "When the user is on the edit job page" do
    before do
      visit '/'
      @faculty_fagan_user = FactoryGirl.create(:faculty_fagan_user)
      login_with_oauth @faculty_fagan_user
      @job = FactoryGirl.create(:job, :supervisors => [@faculty_fagan_user])
      @student_sam = FactoryGirl.create(:student_sam_user)
    end
    it "they can add employees" do
      visit edit_job_path(@job)
      click_link "Add a student"
      fill_in "people_name", :with => "Student Sam"
      click_button('Update Job')

      page.should have_content("Job was successfully updated.")
      page.should have_content("#{@job.title} (Student Sam)")
    end
    it "they can remove employees" do
      @job.employees << @student_sam
      @job.save
      visit edit_job_path(@job)
      within("#employees_in_a_collection") do
        click_on("remove")
      end
      click_button('Update Job')
      page.should have_no_content("#{@job.title} (Student Sam)")
    end

  end



end
