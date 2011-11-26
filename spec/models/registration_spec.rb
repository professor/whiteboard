require 'spec_helper'

describe Registration do
  let(:course) { HubStudentImporter::Course.new }

  describe "#process_import" do
    it "should succeed if given empty array" do
      import_course_data = []
      expect { Registration.process_import( import_course_data ) }.should_not raise_exception
    end

    it "should succeed with one course" do
      import_course_data = [course]
      expect { Registration.process_import( import_course_data ) }.should_not raise_exception
    end

    it "should process duplicate courses" do
      import_course_data = [course] * 2
      expect { Registration.process_import( import_course_data ) }.should_not raise_exception
    end

    it "should return relevant stats" do
      import_course_data = [course] * 2
      results = Registration.process_import( import_course_data )
      results[:failures].size.should == 2
    end
  end
end
