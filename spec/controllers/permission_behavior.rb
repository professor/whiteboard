 shared_examples_for "permission denied" do
    it "can't access page" do
      if @redirect_url.blank?
        response.should redirect_to(root_path)
      else
        response.should redirect_to(@redirect_url)
      end
      flash[:error].should == I18n.t(:no_permission)
    end
 end
  
  shared_examples_for "not editable" do
    it "can't edit object" do
      if @redirect_url.blank?
        response.should redirect_to(root_path)
      else
        response.should redirect_to(@redirect_url)
      end
      flash[:error].should == I18n.t(:not_editable)
    end
  end

  shared_examples_for "permission denied for person deliverable" do
    it "can't access page" do
      if @redirect_url.blank?
        response.should redirect_to(root_path)
      else
        response.should redirect_to(@redirect_url)
      end
      flash[:error].should == I18n.t(:not_your_deliverable)
    end
 end