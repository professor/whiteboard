require 'spec_helper'

describe PasswordResetsController do

  describe 'GET index' do
    before do
      get :index
    end
    it 'should redirect to new password resets path' do
      response.should redirect_to( new_password_reset_path )
    end
  end

  describe 'POST create' do
    before do
      @student_sam = FactoryGirl.create(:student_sam_user,
                                        :password_reset_token=>"ToKeN",
                                        :password_reset_sent_at=>Time.now)
        @active_directory_services = ActiveDirectory.new
    end

    context "valid personal email" do
      it 'should send password reset instructions' do
        User.stub(:find_by_email) { @student_sam }
        ActiveDirectory.stub(:new) { @active_directory_services }
        @active_directory_services.should_receive(:send_password_reset_token)
        post :create, :primaryEmail=>@student_sam.email
      end
    end

    context "invalid personal email" do
      before do
        post :create, :primaryEmail=>"invalid_email"
      end
      it 'should redirect to root_url' do
        response.should redirect_to( new_password_reset_path )
      end
      it 'flash error message' do
        flash[:error].should_not be_nil
      end
    end
  end

  describe 'GET edit' do
    before do
      get :edit, :id => "invalid_url"
    end
    it 'should redirect to new password reset path if reset_link is invalid' do
      response.should redirect_to( new_password_reset_path )
    end
    it 'should flash error if reset_link is invalid' do
      flash[:error].should == "Password reset link has expired."
    end
  end

  describe 'POST update' do
    before do
      @ldap_server = Ladle::Server.new(:quiet => true, :port=>3897).start
      @student_sam = FactoryGirl.create(:student_sam_user,
                                        :password_reset_token=>"ToKeN",
                                        :password_reset_sent_at=>Time.now)
      @active_directory_services = ActiveDirectory.new
      ActiveDirectory.stub(:new).and_return(@active_directory_services)
    end
    after do
      @ldap_server.stop if @ldap_server
    end

    context "success" do
      before do
        @active_directory_services.stub(:reset_password).with(@student_sam, "newPass").and_return("Success")
        put :update, :id => @student_sam.password_reset_token, :newPassword=>"newPass"
      end
      it 'should flash notice with success' do
        flash[:notice].should == "Password has been reset!"
      end
      it 'should redirect to root url' do
        response.should redirect_to( root_url )
      end
    end

    context "failure" do
      before do
        @active_directory_services.stub(:reset_password).with(@student_sam, "newPass").and_return("Any other message")
        put :update, :id => @student_sam.password_reset_token, :newPassword=>"newPass"
      end
      it 'should flash error' do
        flash[:error].should_not be_nil
      end
      it 'should redirect to new_password_reset_path' do
        response.should redirect_to( edit_password_reset_path )
      end
    end
  end
end
