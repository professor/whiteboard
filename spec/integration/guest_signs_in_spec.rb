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
       login_with_oauth Factory(:student_sam)
     end

     it 'only shows content to a logged in user' do
       visit people_path
       page.should have_content('Phone book')
     end
  end

  context 'when logged in' do
     before do
       login_with_oauth Factory(:admin_andy)
#       login_with_oauth Factory(:faculty_frank)
     end

     it 'only shows content to a logged in user' do
       visit sponsored_projects_path
       page.should have_content('Sponsored Projects')
     end
  end

  #Browse to the homepage and click the Sign In link 
  # before do 
  #   visit root_path 
  #   click 'Login' 
  # end

end

#   context 'with valid credentials' do 
# 
#     #Fill in the form with the user's credentials and submit it. 
#     before do 
#       fill_in 'Email', :with => user.email 
#       fill_in 'Password', :with => 'password' 
#       click 'Submit' 
#     end 
# 
#     it 'has a sign out link' do 
#       page.should have_xpath('//a', :text => 'Sign Out') 
#     end 
# 
#     it 'knows who I am' do 
#       page.should have_content("Welcome, #{user.email}!") 
#     end 
# 
#   end 
# 
#   context 'with invalid credentials' do 
# 
#     #No form entry should produce an error 
#     before do 
#       click 'Submit' 
#     end 
# 
#     it 'has errors' do 
#       page.should have_xpath("//div[@id='errorExplanation']") 
#     end 
# 
#   end 
# 
# end
