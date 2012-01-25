require 'spec_helper'

describe PageAttachmentsController do
  context "As a faculty member," do
    before :each do
      @user = Factory(:faculty_frank)
      login @user
      @page = Factory(:page, :is_editable_by_all => false)
      @attachment = Factory(:page_attachment, :page => @page, :user => @user)
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
        post :create, :page_attachment => Factory.build(:page_attachment, :page_id => @page.id).attributes
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
        def do_post
          post :create, :page_attachment => Factory.build(:blank_page_attachment, :page_id => @page.id).attributes
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
      end
    end

    describe "DELETE destroy" do
      def do_delete
        delete :destroy, :id => @attachment.id
      end

      it "should delete the attachment" do
        expect do
          do_delete
        end.to change { PageAttachment.count }.by(-1)
      end

      it "should flash a notice" do
        do_delete
        flash[:notice].should_not be_nil
      end
    end
  end

  context "As a student, on a page that is not editable by everyone," do
    before :each do
      @user = Factory(:student_sam)
      login @user
      @page = Factory(:page, :is_editable_by_all => false)
      @attachment = Factory(:page_attachment, :page => @page)
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
        post :create, :page_attachment => Factory.build(:page_attachment, :page_id => @page.id.to_s).attributes
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
