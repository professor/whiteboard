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
    @user = FactoryGirl.create(:student_sam_user)

    login_with_oauth @user
    click_link "People"
  end

  it "Should have no results at the beginning" do
    page.should have_selector('#results_box')
    page.should_not have_selector('#results_box .data_card')
  end


# MERGE TRY
  context 'display team names along with course' do

    before do

      @course_fse  = Course.create(name: "Foundation of Software Engineering", short_name: "FSE", semester: "Fall", year: "2012", mini: "Both")
      @course_req  = Course.create(name: "Requirement Engineering", short_name: "Req", semester: "Fall", year: "2012", mini: "A")
      @course_arch  = Course.create(name: "Architecture and Design", short_name: "Arch", semester: "Fall", year: "2012", mini: "B")

  #    @stu_rashmi = User.create(first_name: "Rashmi", last_name: "Dev", email: "rashmi.dr@sv.cmu.edu", webiso_account: "rdev@andrew.cmu.edu", is_student: true, graduation_year:"2013",teams: [@team_mav,@team_coop])
  #    @stu_shama = User.create(first_name: "Shama", last_name: "Hoq", email: "shama.hoq@sv.cmu.edu", webiso_account: "shoq@andrew.cmu.edu", is_student: true, graduation_year:"2013",teams: [@team_mav,@team_leffing])

      @team_mav = Team.create(name: "Maverick", email: "maverick@sv.cmu.edu", course_id: @course_fse.id)
      @team_coop = Team.create(name: "Cooper", email: "cooper@sv.cmu.edu", course_id: @course_req.id)
      @team_leffing =  Team.create(name: "Leffingwell", email: "leffingwell@sv.cmu.edu", course_id: @course_req.id)
      @team_amigo =  Team.create(name: "Amigos", email: "amigos@sv.cmu.edu", course_id: @course_fse.id)

      @stu_rashmi = User.create(first_name: "Rashmi", last_name: "Dev", email: "rashmi.dr@sv.cmu.edu", webiso_account: "rdev@andrew.cmu.edu", is_student: true, graduation_year:"2013")#,team_names:[@team_coop, @team_mav])
      @stu_shama = User.create(first_name: "Shama", last_name: "Hoq", email: "shama.hoq@sv.cmu.edu", webiso_account: "shoq@andrew.cmu.edu", is_student: true, graduation_year:"2013") #, team_names: [@team_leffing,@team_mav])

      @stu_rashmi.teams = [@team_mav,@team_coop]
      @stu_shama.teams = [@team_mav,@team_leffing]

    end

    it "display team names along with course for every student", :js => true do
      fill_in "search_text_box" , :with => "Rashmi"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', text: "Teams: Cooper (Course: Req) Maverick (Course: FSE)")

    end
  end
# END MERGE


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
      #page.should have_content('Vidya')
      page.should_not have_content('Shama')
    end

    it "Search by Andrew ID",  :js => true do
      fill_in "search_text_box" , :with => "ali"
      page.find(:css, '#criteria_first_name a').click
      page.find(:css, '#criteria_last_name a').click
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should have_content('Clyde')
    end

    #need to be implemented
    it "Search by class year", :js => true do
      select 'Class Year', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_class_year select').select('2013')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should_not have_content('Sam')

    end

    # need to be implemented
    it "Search by program", :js => true do
      select 'Program', :from => 'extra_criteria_picker'
      #select 'SE-DM', :from => page.find(:css, '#criteria_program select')
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

    it "Search by exact Last Name / Student / Program", :js => true do
      select 'Student', :from => 'people_type_picker'
      select 'Program', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_program select').select('SM')
      page.find(:css, "#exact_match_checkbox").set(true)
      fill_in "search_text_box" , :with => "Li"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Clyde")
      page.should_not have_content("Charlie")
      page.should_not have_content("Allen")
      page.should_not have_content("Sean")
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