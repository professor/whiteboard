 shared_examples_for "permission denied" do
    it "can't access page" do
      response.should redirect_to(root_url)
      flash[:error].should == I18n.t(:no_permission)
    end
 end