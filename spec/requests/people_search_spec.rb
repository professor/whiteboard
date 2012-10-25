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


  context 'with search results' do

    before do
      fill_in "search_text_box" , :with => "Sam"

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

    it "Search by Part Time / Staff", :js => true do
      select 'Staff', :from => 'people_type_picker'
      select 'Full/Part Time', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_ft_pt select').select('Part Time')
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Allen")
      page.should_not have_content("Sam")
      page.should_not have_content("Sally")
      page.should_not have_content("Clyde")
      page.should_not have_content("Ed")
      page.should_not have_content("Todd")
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