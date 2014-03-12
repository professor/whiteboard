require 'spec_helper'

describe GenericAjaxController do

  context "get update_model_with_value" do

    context "for a valid request" do
      before :each do
        @user = FactoryGirl.create(:student_sam_user)
        login(@user)
        @instance = @user
        User.stub(:find_by_id).and_return(@instance)
      end

      it 'should call can? for authorization check' do
        ability = Object.new
        ability.extend(CanCan::Ability)
        controller.stub(:current_ability).and_return(ability)
        ability.should_receive(:can?)

        post :update_model_with_value, :model => 'User', :id => @user.id, :attribute => 'course_tools_view', :value => 'links'
      end

      it 'should update the value for a model ' do
        #@user = FactoryGirl.create(:faculty_frank)
        #login @user

        User.should_receive(:find_by_id)
#        @instance.should_receive(:course_tools_view=).with('links')
        @instance.should_receive(:update_attribute).with('course_tools_view','links')
        post :update_model_with_value, :model => 'User', :id => @user.id, :attribute => 'course_tools_view', :value => 'links'
      end
    end


    context 'should handle invalid inputs' do
      it 'like a model that does not exist'
      it "like a row that isn't in the database"
      it "like a method that the model doesn't have"
    end

  end


end
