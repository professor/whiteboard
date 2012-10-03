require "rspec"

describe "PeopleSearch" do

  before do
    visit('/people')
  end
  it "people_table should be empty when search box is blank"
  it "people_table should be populated as key words are inserted to the search box"
  it "people_table should display less than ten rows by default"
  it "people images should be fetched only for displayed rows"
  it "all rows should be displayed when search button is clicked"

end