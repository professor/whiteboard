require_relative '../../app/services/people_in_a_collection.rb'

describe PeopleInACollection do

  let(:class_with_people_in_a_collection) {
    Class.new do
      include PeopleInACollection

      attr_accessor :names_override
    end
  }

#  subject { class_with_people_in_a_collection.new }

  context "validate_members validator" do

    it "when there is a person name typo, then it should add an error to base" do
      test_class = class_with_people_in_a_collection.new

      test_class.names_override = ["Student Sam", "BBBBB"]

      test_class.stub(:map_member_strings_to_users) { ["Student Sam", nil] }

      test_class.stub_chain(:errors, :add)
      test_class.should_receive(:errors)
      test_class.validate_members :names_override

    end

    it "when all the names are correct, then it should not add errors to base" do
      test_class = class_with_people_in_a_collection.new

      test_class.names_override = ["Student Sam", "Faculty Frank"]

      test_class.stub(:map_member_strings_to_users) { ["Student Sam", "Faculty Frank"] }

      test_class.stub_chain(:errors, :add)
      test_class.should_not_receive(:errors)
      test_class.validate_members :names_override
    end
  end

  context "update_members " do
    # This method converts an array of strings to user objects and associate

    "given a symbol that represents list of user strings"
    "given a symbol that represents an association array"
    "it should replace the existing association with a new association"
    "it should set the list of user strings to be empty"


  end



end
