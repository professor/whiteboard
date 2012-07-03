require 'spec_helper'

describe "individual_contributions/edit.html.erb" do
  before(:each) do
    assign(:questions, ["Q1", "Q2"])
    assign(:answer_input_types, [:text_area, :text_field])
    @fse = FactoryGirl.build(:fse_current_semester)
    assign(:courses, [@fse] )
    assign(:plans_from_previous_week, {@fse.id => "I plan to go to the moon"} )
    assign(:answers_for_this_week, [ {@fse.id => "I made it! It's full of cheese"},  {@fse.id => 10.5}] )


#    @this_week = assign(:project, stub_model(IndividualContribtion, :new_record? => false))
#    assign(:sponsors, [FactoryGirl.build(:sponsored_project_sponsor), FactoryGirl.build(:sponsored_project_sponsor)])
  end

  it "renders edit form" do
    render

    rendered.should have_selector("form", :action => "/individual_contributions/update", :method => "post")
  end


end
