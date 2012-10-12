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
      click_button "submit_btn"
    end

    it "Should display images with the search results", :js => true do
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card img')
    end

  end

  context ' search by single criteria' do

    it "should search with partial match", :js => true do
      fill_in "search_text_box" , :with => "sh"
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Rashmi")
      page.should have_selector('#results_box .data_card', :content => "Shama")
    end

    it "should search with exact match", :js => true do
      fill_in "search_text_box" , :with => "Sham"
      find(:css, "#exact_match_checkbox").set(true)
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should_not have_content "Shama"
    end


    it "Search by company names ", :js => true do
      select 'Company', :from => 'extra_criteria_picker'
      find('#criteria_company input').set('LinkedIn')
      #fill_in "criteria_company_text", :with => "LinkedIn"
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => 'Vidya')
      #page.should have_content('Vidya')
      page.should_not have_content('Shama')
    end

    it "Search by Andrew ID",  :js => true do
      fill_in "search_text_box" , :with => "ali"
      page.find(:css, '#criteria_first_name a').click
      page.find(:css, '#criteria_last_name a').click
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should have_content('Clyde')
    end

    #need to be implemented
    it "Search by class year", :js => true do
      select 'Class Year', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_class_year select').select('2013')
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should_not have_content('Sam')

    end

    # need to be implemented
    it "Search by program", :js => true do
      select 'Program', :from => 'extra_criteria_picker'
      #select 'SE-DM', :from => page.find(:css, '#criteria_program select')
      page.find(:css, '#criteria_program select').select('SE-DM')
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Rashmi")
      page.should_not have_content('Vidya')
    end

    it "Filter by people type", :js => true do
      select 'Student', :from => 'people_type_picker'
      click_button "submit_btn"
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
      click_button "submit_btn"
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
      click_button "submit_btn"
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
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Clyde")
      page.should_not have_content("Charlie")
      page.should_not have_content("Allen")
      page.should_not have_content("Sean")
    end

  end




end