# require 'spec_helper' 
# 
# context 'as a guest on the sign in page' do 
# 
#   #Make sure your factory generates a valid user for your authentication system 
#   let(:user) { Factory(:student_sam) } 
# 
#   #Browse to the homepage and click the Sign In link 
#   # before do 
#   #   visit root_path 
#   #   click 'Login' 
#   # end
#   it 'welcomes the user' do
#     visit '/'
#     page.should have_content('Welcome')
#   end 
#   
#   it 'test' do
#     click 'Effort Logs'
#   end
# end
# 
# #   context 'with valid credentials' do 
# # 
# #     #Fill in the form with the user's credentials and submit it. 
# #     before do 
# #       fill_in 'Email', :with => user.email 
# #       fill_in 'Password', :with => 'password' 
# #       click 'Submit' 
# #     end 
# # 
# #     it 'has a sign out link' do 
# #       page.should have_xpath('//a', :text => 'Sign Out') 
# #     end 
# # 
# #     it 'knows who I am' do 
# #       page.should have_content("Welcome, #{user.email}!") 
# #     end 
# # 
# #   end 
# # 
# #   context 'with invalid credentials' do 
# # 
# #     #No form entry should produce an error 
# #     before do 
# #       click 'Submit' 
# #     end 
# # 
# #     it 'has errors' do 
# #       page.should have_xpath("//div[@id='errorExplanation']") 
# #     end 
# # 
# #   end 
# # 
# # end
