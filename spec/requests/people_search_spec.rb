require "spec_helper"

describe "people search" do

  before do
    visit('/')
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
      fill_in "search_text_box" , :with => "Shama"
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => "Shama")
    end


    it "Search by company names ", :js => true do
      select 'Company', :from => 'extra_criteria_picker'
      find('#criteria_company input').set('Linked')
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card', :content => 'Vidya')
      page.should have_content('Vidya')
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

    it "Search by class year", :js => true do
      select 'Class Year', :from => 'extra_criteria_picker'
      page.find(:css, '#criteria_class_year select').select('2013')
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should have_content('Rashmi')

    end

    it "Search by program", :js => true do
      select 'Program', :from => 'extra_criteria_picker'
      #select 'SE-DM', :from => page.find(:css, '#criteria_program select')
      page.find(:css, '#criteria_program select').select('SE-DM')
      click_button "submit_btn"
      wait_until { page.evaluate_script("jQuery.active") == 0 }
      page.should have_selector('#results_box .data_card')
      page.should have_content('Rashmi')
      page.should_not have_content('Vidya')
    end

  end


  context ''



end