require "spec_helper"

describe "people search" do

  before do
    visit('/')
    FactoryGirl.create(:faculty_allen)
    FactoryGirl.create(:faculty_todd)
    FactoryGirl.create(:faculty_ed)
    FactoryGirl.create(:alumnus_sean)
    FactoryGirl.create(:alumnus_memo)
    FactoryGirl.create(:alumnus_sunil)
    FactoryGirl.create(:student_charlie)
    FactoryGirl.create(:student_clyde)
    FactoryGirl.create(:student_rashmi)
    FactoryGirl.create(:student_shama)
    FactoryGirl.create(:student_vidya)
    FactoryGirl.create(:alumnus_harry)
    @user = FactoryGirl.create(:student_sam_user)

    login_with_oauth @user
    click_link "People"
  end

  it "Should have no results at the beginning" do
    page.should have_selector('#results_box')
    page.should_not have_selector('#results_box .data_card')
  end

  #Tests for active/inactive users

  context 'active/inactive users' do
    it "should include only active users by default, then update with inactive users only on checking the 'Include Inactive Users'", :js => true do
      fill_in "search_text_box" , :with => "Harr"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => "Harry")
      find(:css, "#include_inactive_checkbox").set(true)
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Harry")
    end

    it "should include even inactive users on checking 'Include Inactive Users'", :js => true do
      fill_in "search_text_box" , :with => "Harry"
      find(:css, "#include_inactive_checkbox").set(true)
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Harry")
    end
  end
  #Tests for customization
  context 'customization of the search result' do

    it "should display only the fields selected in the customization window", :js => true do
      find(:css, "#photo_checkbox").set(false)
      find(:css, "#email_checkbox").set(true)
      find(:css, "#phone_home_checkbox").set(false)
      find(:css, "#phone_mobile_checkbox").set(false)
      find(:css, "#team_checkbox").set(false)
      find(:css, "#company_checkbox").set(true)
      page.find(:css, '#customization_dialog_close').click

      fill_in "smart_search_text" , :with => "Sam"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Sam')
      page.should have_selector('#results_box .data_card', text: "student.sam@sv.cmu.edu")


      #page.should have_selector('#results_box .data_card', text: "Company")
      page.should_not have_selector('#results_box .data_card', text: "Work")
      page.should_not have_selector('#results_box .data_card', text: "Mobile")
      page.should_not have_selector('#results_box .data_card', text: "Team")
      page.should_not have_selector('#results_box .data_card img', visible: true)

    end

  end


# Tests written for Simple(Smart) Search

  context 'smart search capability' do
    it "should search for human name", :js => true do
      fill_in "smart_search_text" , :with => "clyde"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Clyde')
    end

    it "should recognize and search for company name", :js => true do
      fill_in "smart_search_text" , :with => "google"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Clyde')
      page.should have_selector('#results_box .data_card', :text => 'Allen')
    end

    it "should recognize and search for class year", :js => true do
      fill_in "smart_search_text" , :with => "2013"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Clyde')
      page.should have_selector('#results_box .data_card', :text => 'Shama')
      page.should have_selector('#results_box .data_card', :text => 'Rashmi')
      page.should have_selector('#results_box .data_card', :text => 'Charlie')
      page.should have_selector('#results_box .data_card', :text => 'Vidya')
      page.should_not have_selector('#results_box .data_card', :text => 'Sunil')
      page.should_not have_selector('#results_box .data_card', :text => 'Allen')
    end

    it "should recognize and search for program", :js => true do
      fill_in "smart_search_text" , :with => "SE TECH"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Shama')
      page.should_not have_selector('#results_box .data_card', :text => 'Clyde')
      page.should_not have_selector('#results_box .data_card', :text => 'Rashmi')
      page.should_not have_selector('#results_box .data_card', :text => 'Vidya')
    end

    it "should recognize and search for FT/PT", :js => true do
      fill_in "smart_search_text" , :with => "full time"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Shama')
      page.should have_selector('#results_box .data_card', :text => 'Clyde')
      page.should have_selector('#results_box .data_card', :text => 'Rashmi')
      page.should have_selector('#results_box .data_card', :text => 'Vidya')
      page.should_not have_selector('#results_box .data_card', :text => 'Sam')
      page.should_not have_selector('#results_box .data_card', :text => 'Sally')
    end

    it "should recognize and search for people type", :js => true do
      fill_in "smart_search_text" , :with => "faculty"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Allen')
      page.should have_selector('#results_box .data_card', :text => 'Todd')
      page.should have_selector('#results_box .data_card', :text => 'Ed')
      page.should_not have_selector('#results_box .data_card', :text => 'Shama')
      page.should_not have_selector('#results_box .data_card', :text => 'Sunil')
    end

    it "should recognize and search for name AND company", :js => true do
      fill_in "smart_search_text" , :with => "todd google"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card')
      fill_in "smart_search_text" , :with => "todd yahoo"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Todd')
    end

    it "should recognize and search for combination of class year / FT or PT / program", :js => true do
      fill_in "smart_search_text" , :with => "2013 FT SE"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Rashmi')
      page.should have_selector('#results_box .data_card', :text => 'Shama')
      page.should_not have_selector('#results_box .data_card', :text => 'Sam')
      page.should_not have_selector('#results_box .data_card', :text => 'Sunil')
    end

  end


  context 'display and use linkable urls and back button' do

    it "should generate linkable url", :js => true do

      fill_in "search_text_box" , :with => "vid"
      find(:css, "#exact_match_checkbox").set(true)
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => 'Vidya')
      URI.parse(current_url).fragment.should == "&smart_search_text=&main_search_text=vid&first_name=true&last_name=true&andrew_id=true&exact_match=true"
    end

    it "Should display result page with an entry of a linkable url", :js => true do

      visit ("/people#&main_search_text=Vid&first_name=true&last_name=true&andrew_id=true&people_type=student&class_year=2013")
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Vidya')

    end

    it "Should go back to the previous search page on clicking back button", :js => true do
      visit ("/people#&main_search_text=Vid&first_name=true&last_name=true&andrew_id=true&people_type=student&class_year=2013")
      visit ("/people#&main_search_text=Todd&first_name=true&last_name=true&andrew_id=true&people_type=staff&organization_name=yahoo")
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Todd')

      page.evaluate_script('window.history.back()')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Vidya')
    end

  end


  context 'display team names along with course' do

    before do
      @course_fse  = Course.create(name: "Foundation of Software Engineering", short_name: "FSE", semester: "Fall", year: "2012", mini: "Both")
      @course_req  = Course.create(name: "Requirement Engineering", short_name: "Req", semester: "Fall", year: "2012", mini: "A")
      @course_arch  = Course.create(name: "Architecture and Design", short_name: "Arch", semester: "Fall", year: "2012", mini: "B")

      @team_mav = Team.create(name: "Maverick", email: "maverick@sv.cmu.edu", course_id: @course_fse.id)
      @team_coop = Team.create(name: "Cooper", email: "cooper@sv.cmu.edu", course_id: @course_req.id)
      @team_leffing =  Team.create(name: "Leffingwell", email: "leffingwell@sv.cmu.edu", course_id: @course_req.id)
      @team_amigo =  Team.create(name: "Amigos", email: "amigos@sv.cmu.edu", course_id: @course_fse.id)

      @stu_rashmi = User.create(first_name: "Rashmi", last_name: "Dev", email: "rashmi.dr@sv.cmu.edu", webiso_account: "rdev@andrew.cmu.edu", is_student: true, graduation_year:"2013", is_active: true)
      @stu_shama = User.create(first_name: "Shama", last_name: "Hoq", email: "shama.hoq@sv.cmu.edu", webiso_account: "shoq@andrew.cmu.edu", is_student: true, graduation_year:"2013", is_active: true)

      @stu_rashmi.teams = [@team_mav,@team_coop]
      @stu_shama.teams = [@team_mav,@team_leffing]
    end

    it "display team names along with course for every student", :js => true do
      find(:css, "#team_checkbox").set(true)
      page.find(:css, '#customization_dialog_close').click
      fill_in "search_text_box" , :with => "Rashmi"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', text: "Teams")
      page.should have_selector('#results_box .data_card', text: "Cooper (Course: Req)")
      page.should have_selector('#results_box .data_card', text: "Maverick (Course: FSE)")
    end
  end


  context 'with search results' do

    before do
      fill_in "search_text_box" , :with => "Sam"
    end

    it "should display only fields that are filled in", :js => true  do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Work")
      page.should have_selector('#results_box .data_card', :text => "123-456-789")
      page.should have_selector('#results_box .data_card', :text => "Mobile")
      page.should have_selector('#results_box .data_card', :text => "321-654-987")
      fill_in "search_text_box" , :with => "Allen"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Work")
      page.should have_selector('#results_box .data_card', :text => "213-654-123")
      page.should_not have_selector('#results_box .data_card', :text => "Mobile")

      fill_in "search_text_box" , :with => "sean"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => "Work")
      page.should_not have_selector('#results_box .data_card', :text => "Mobile")
    end

    it "should update on change of search text string", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Sam")
      fill_in "search_text_box" , :with => "Todd"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Todd")
    end

    it "should update on change of user type", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Sam")
      select 'Alumni', :from => 'people_type_picker'
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => "Sam")
    end

    it "should update on change of criteria", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Sam")
      select 'Company', :from => 'extra_criteria_picker'
      find('#criteria_company input').set('LinkedIn')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => "Sam")
      fill_in "search_text_box" , :with => "Vidya"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Vidya')
    end

    it "should update on selection of exact match", :js => true do
      fill_in "search_text_box" , :with => "Vid"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => 'Vidya')
      find(:css, "#exact_match_checkbox").set(true)
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => 'Vidya')
    end

    it "Should display images with the search results", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card img')
    end

    #Test for displaying andrew id when searched for
    it "should display andrew id when searched by only andrew id", :js => true do
      fill_in "search_text_box" , :with => "Sam"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_selector('#results_box .data_card', :text => "sam@andrew.cmu.edu")
      select 'Only Andrew ID', :from => 'main_criteria_picker'
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "sam@andrew.cmu.edu")
    end


  end

  context ' search by single criteria' do

    it "should search with partial match", :js => true do
      fill_in "search_text_box" , :with => "sh"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :text => "Rashmi")
      page.should have_selector('#results_box .data_card', :text => "Shama")
    end

    it "should search with exact match", :js => true do
      fill_in "search_text_box" , :with => "Sham"
      find(:css, "#exact_match_checkbox").set(true)
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_content "Shama"
    end


    it "Search by company names ", :js => true do
      select 'Company', :from => 'extra_criteria_picker'
      find('#criteria_company input').set('LinkedIn')
      #fill_in "criteria_company_text", :with => "LinkedIn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => 'Vidya')
      page.should_not have_content('Shama')
    end

    it "Search by class year", :js => true do
      select 'Class Year', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_class_year select').select('2013')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should_not have_content('Sam')

    end

    it "Search by program", :js => true do
      select 'Program', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_program select').select('SE-DM')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Rashmi")
      page.should_not have_content('Vidya')
    end

    it "Filter by people type", :js => true do
      select 'Student', :from => 'people_type_picker'
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Clyde")
      page.should have_selector('#results_box .data_card', :content => "Rashmi")
      page.should have_selector('#results_box .data_card', :content => "Shama")
      page.should have_selector('#results_box .data_card', :content => "Vidya")
      page.should have_selector('#results_box .data_card', :content => "Sam")
      page.should_not have_content("Sunil")
    end

  end

  context "Criteria Combinitation Test" do
    it "Search by Class Year / Alumni ", :js => true do
      select 'Alumni', :from => 'people_type_picker'
      select 'Class Year', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_class_year select').select('2010')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Sunil")
      page.should have_selector('#results_box .data_card', :content => "Memo")
      page.should_not have_content("Sean")
      page.should_not have_content("Clyde")
    end

    it "Search by partial First Name / Company / Staff ", :js => true do
      select 'Staff', :from => 'people_type_picker'
      select 'Company', :from => 'extra_criteria_picker'
      find('#criteria_company input').set('yahoo')
      fill_in "search_text_box" , :with => "o"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Todd")
      page.should_not have_content("Memo")
      page.should_not have_content("Allen")
      page.should_not have_content("Ed")
      page.should_not have_content("Clyde")
    end

    it "Search by Full Time / Student", :js => true do
      select 'Student', :from => 'people_type_picker'
      select 'Full/Part Time', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_ft_pt select').select('Full Time')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Clyde")
      page.should have_selector('#results_box .data_card', :content => "Rashmi")
      page.should have_selector('#results_box .data_card', :content => "Shama")
      page.should have_selector('#results_box .data_card', :content => "Vidya")
      page.should_not have_content("Sam")
      page.should_not have_content("Sally")
      page.should_not have_content("Allen")
    end


  end




end