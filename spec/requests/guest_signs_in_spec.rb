require 'spec_helper'

describe 'A user visiting the site', :type => :request do

  context 'when not logged in' do
    it 'welcomes the user' do
      visit root_path
      page.should have_content('CARNEGIE MELLON SILICON VALLEY')
    end
  end
  
  context 'when logged in' do
     before do
       @user = Factory(:student_sam)
       login_with_oauth @user
     end

     it 'only shows content to a logged in user' do
       visit people_path
       page.should have_content('Phone book')
     end

     it 'has a logout link' do
      visit('/')
      page.should have_link("Logout " "#{@user.first_name}")
     end

     # does not show flash here
     #it 'knows who am I' do
     #  visit('/')
     #  page.should have_content("#{@user.email}")
     #end
  end

  context 'when logged in' do
     before do
        @user =  Factory(:faculty_frank)
        login_with_oauth @user
        visit my_teams_path(@user.id)
     end

     it 'only shows content to a logged in user' do
       page.should have_content('My Teams')
     end
  end

  context 'when logged in' do
     before do
       login_with_oauth Factory(:admin_andy)
     end

     it 'only shows content to a logged in user' do
       visit sponsored_projects_path
       page.should have_content('Sponsored Projects')
     end
  end
end

