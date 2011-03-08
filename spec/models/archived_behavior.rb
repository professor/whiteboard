# @current =  Factory(:sponsored_project_sponsor, :is_archived => false)
# @archive =  Factory(:sponsored_project_sponsor, :is_archived => true)

  shared_examples_for "archived objects" do
    it "should respond to current" do
      @current.class.should respond_to(:current)
    end

    it "current includes only current" do
      current_items = @current.class.current
      current_items.length.should == 1
      current_items[0].should == @current
    end

    it "should respond to archived" do
      @current.class.should respond_to(:archived)
    end

    it "archived includes only archived" do
      archived_items = @current.class.archived
      archived_items.length.should == 1
      archived_items[0].should == @archived
    end
  end