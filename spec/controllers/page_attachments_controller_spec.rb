require 'spec_helper'

describe PageAttachmentsController do

  describe "post create" do
    before(:each) do
      @page = Factory(:page)
      @page_attachment = PageAttachment.new
      @page_attachment.name = "Picture"
      @page_attachment.attachment = File.new(Rails.root + 'spec/fixtures/sample_photo.png')
      @page_attachment.page_id = @page.id
      @attr = @page_attachment.attributes
    end
    it "should create successfully" do
       lambda do
        post :create, :page_attachment => @attr
        end.should change(PageAttachment,:count).by(1)
      flash[:error].should_not == 'Must specify a file to upload'
        flash[:notice].should == "Attachment was successfully added."
        assigns(:page_attachment).name.should == @page_attachment.name
    end
  end

  describe "get edit" do
    it "should find the page_attachment to edit successfully" do
      login(Factory(:faculty_frank))

     @page = Factory(:page)
      @page_attachment = PageAttachment.new
      @page_attachment.name = "Picture"
      @page_attachment.attachment = File.new(Rails.root + 'spec/fixtures/sample_photo.png')
      @page_attachment.page = @page
    @page_attachment.save

      get :edit, :id => @page_attachment.id
      assigns(:page_attachment).should == @page_attachment
    end

  end

  describe "post update" do
    it "should update correctly" do
        login(Factory(:faculty_frank))

     @page = Factory(:page)
      @page_attachment = PageAttachment.new
      @page_attachment.name = "Picture"
      @page_attachment.attachment = File.new(Rails.root + 'spec/fixtures/sample_photo.png')
      @page_attachment.page = @page
    @page_attachment.save
      @new_page_attach = PageAttachment.new(@page_attachment.attributes)
        @new_page_attach.name = "Second Picture"
      put :update, :id => @page_attachment.id, :page_attachment => @new_page_attach.attributes
        flash[:notice].should == 'Attachment was successfully updated.'
        assigns(:page_attachment).name.should == @new_page_attach.name
    end
  end
end
