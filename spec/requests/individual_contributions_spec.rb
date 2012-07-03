require "spec_helper"

describe "individual_contributions" do

  context "Given the user is logged in as a student" do
    before do
      visit('/')
      @user = FactoryGirl.create(:student_sam_user_with_registered_courses)
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      login_with_oauth @user
    end


    context "And that it is the current week" do
      context "When the user visits the index " do
        before do
          visit('/individual_contributions')
        end

        it "Then it renders" do
          page.should have_content("Individual Contributions")
          page.should have_content("Week #{Date.today.cweek} of #{Date.today.year}")
          page.should have_link("New Individual Contribution")
        end
      end

      context "And the user has already entered data" do
        before do
          @fse = @user.registered_courses[0]
          @mfse = @user.registered_courses[1]
          @previous_week = FactoryGirl.create(:individual_contribution, :user => @user, :week_number => Date.today.cweek - 1, :year => Date.today.cwyear)
          @mfse_previous_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @previous_week, :course => @mfse, :answer5 => "I did great")
          @fse_previous_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @previous_week, :course => @fse, :answer5 => "I finished it")

          @current_week = FactoryGirl.create(:individual_contribution, :user => @user, :week_number => Date.today.cweek, :year => Date.today.cwyear)
          @mfse_current_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @current_week, :course => @mfse,
                                                     :answer1 => "I dreamed a dream",
                                                     :answer2 => "40.5",
                                                     :answer3 => "Only the speed of light is my obstacle",
                                                     :answer4 => "Get really really small",
                                                     :answer5 => "I will take over the world")
          @fse_current_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @current_week, :course => @fse,
                                                    :answer1 => "I want a job",
                                                    :answer2 => "30.5",
                                                    :answer3 => "Algorithms is my obstacle",
                                                    :answer4 => "study study and study",
                                                    :answer5 => "take a vacation")
        end
        context "When the user clicks on Edit" do

          it "Then the edit page renders" do
            click_link('Edit')

            page.should have_content("This was your plan for this week")
            page.should have_content("FSE")
            page.should have_content("I did great")
            page.should have_content("I finished it")


          end

        end
      end

    end


  end
end