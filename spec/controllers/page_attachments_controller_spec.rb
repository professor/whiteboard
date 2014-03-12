require 'spec_helper'

describe PageAttachmentsController do
  context "As a faculty member," do
    before :each do
      @user = FactoryGirl.create(:faculty_frank)
      login @user
      @page = FactoryGirl.create(:page, :is_editable_by_all => false)
      @attachment = FactoryGirl.create(:page_attachment, :page => @page, :user => @user)
    end

    describe "performing PUT update on a page attachment" do
      before do
        put :update, :id => @attachment.id, :page_attachment => @attachment.attributes
      end

      it "should redirect to the page" do
        should redirect_to @page
      end
    end

    describe "POST create" do
      def do_post
        post :create, :page_attachment => FactoryGirl.build(:page_attachment, :page_id => @page.id).attributes
      end

      it "should create the attachment" do
        expect do
          do_post
        end.to change { PageAttachment.count }.by(1)
      end

      it "should redirect to the page" do
        do_post
        should redirect_to @page
      end

      context "if there is no file" do
        before do
          @blank_attachment = FactoryGirl.build(:blank_page_attachment, :page => @page)
        end

        def do_post
          post :create, :page_attachment => @blank_attachment.attributes
        end

        it "should not create the attachment" do
          PageAttachment.stub(:new).and_return(@blank_attachment)
          @blank_attachment.page.should_receive(:editable?).and_return(true)
          @blank_attachment.page_attachment.should_receive(:present?)
          @blank_attachment.should_not_receive(:save)
          do_post
        end

        it "should flash an error" do
          do_post
          flash[:error].should_not be_nil
        end
      end
    end

    describe "DELETE destroy" do
      def do_delete
        delete :destroy, :id => @attachment.id

      end

      it "should delete the attachment", :skip_on_build_machine => true  do
        @attachment.page.should_receive(:editable?).and_return(true)
        @attachment.should_receive(:destroy)

        PageAttachment.stub(:find).with(@attachment.id.to_s).and_return(@attachment)
        do_delete
      end

      it "should flash a notice", :skip_on_build_machine => true do
        @attachment.page.should_receive(:editable?).and_return(true)
        @attachment.stub(:destroy)
        PageAttachment.stub(:find).with(@attachment.id.to_s).and_return(@attachment)

        do_delete
        flash[:notice].should_not be_nil
      end



    end
  end

  context "As a student, on a page that is not editable by everyone," do
    before :each do
      @user = FactoryGirl.create(:student_sam)
      login @user
      @page = FactoryGirl.create(:page, :is_editable_by_all => false)
      @attachment = FactoryGirl.create(:page_attachment, :page => @page, :user_id => 1)
    end

    describe "performing PUT update on a page attachment" do
      before do
        put :update, :id => @attachment.id, :page_attachment => @attachment.attributes
      end

      it "should flash an error" do
        flash[:error].should_not be_nil
      end

      it "should redirect to the page" do
        should redirect_to @page
      end
    end

    describe "POST create" do
      def do_post
        post :create, :page_attachment => FactoryGirl.build(:page_attachment, :page_id => @page.id.to_s).attributes
      end

      it "should not create the attachment" do
        expect do
          do_post
        end.to change { PageAttachment.count }.by(0)
      end

      it "should flash an error" do
        do_post
        flash[:error].should_not be_nil
      end

      it "should redirect to the page" do
        do_post
        should redirect_to @page
      end
    end

    describe "DELETE destroy" do
      it "should not delete the attachment" do
        expect do
          delete :destroy, :id => @attachment.id
        end.to change { PageAttachment.count }.by(0)
      end
    end
  end
end
