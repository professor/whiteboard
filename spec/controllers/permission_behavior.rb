 shared_examples_for "permission denied" do
    it "can't access page" do
      if @redirect_url.blank?
        response.should redirect_to(root_url)
      else
        response.should redirect_to(@redirect_url)
      end
      flash[:error].should == I18n.t(:no_permission)
    end
 end