require File.join(File.dirname(__FILE__), "../../../../lib/cmusv/hub_student_importer/hub_student_importer")

describe HubStudentImporter do
  let(:rtf_src) do
    # return some test rtf source code
    "{\\rtf1\\ansi\\ansicpg1252\\cocoartf1138\\cocoasubrtf230
    {\\fonttbl\\f0\\fswiss\\fcharset0 ArialMT;}
    {\\colortbl;\\red255\\green255\\blue255;\\red26\\green26\\blue26;\\red255\\green252\\blue125;}
    \\margl1440\\margr1440\\vieww27540\\viewh16600\\viewkind0
    \\deftab720
    \\pard\\pardeftab720

    \\f0\\fs26 \\cf0 \\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0CLASS \\cf2 \\cb3 ROSTER\\cf0 \\cb1 \\
    \\
    Run Date: 18-jul-2011 \\'a0 \\'a0 \\'a0Course: 96700 \\'a0Sect: A \\'a0 FOUNDATNS SW ENG\\
    Semester: F11 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0College: \\'a0CIT \\'a0Department: \\'a0SV\\
    \\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Instructor(s): SEDANO, A.\\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0KATZ, E.\\
    \\
    Name \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0Class \\'a0Col Dept G/O \\'a0Units UserID \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Mid Fin Def\\
    _______________________________________________________________________________________\\
    \\
    AGGARWAL, CHARU \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Master CIT SV \\'a0 M \\'a0 \\'a024.0 \\'a0caggarwa\\
    \\
    \\
    Total Number Of Students In Course \\'a096700 \\'a0Section \\'a0A \\'a0 is \\'a0 \\'a0 \\'a0 \\'a01\\
    \\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0CLASS \\cf2 \\cb3 ROSTER\\cf0 \\cb1 \\
    \\
    Run Date: 18-jul-2011 \\'a0 \\'a0 \\'a0Course: 96700 \\'a0Sect: B \\'a0 FOUNDATNS SW ENG\\
    Semester: F11 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0College: \\'a0CIT \\'a0Department: \\'a0SV\\
    \\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Instructor(s): SEDANO, A.\\
    \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0KATZ, E.\\
    \\
    Name \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0Class \\'a0Col Dept G/O \\'a0Units UserID \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Mid Fin Def\\
    _______________________________________________________________________________________\\
    \\
    BAILEY, BRIAN \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 \\'a0 Master CIT SV \\'a0 M \\'a0 \\'a024.0 \\'a0brianbai\\
    \\
    BOND, JOSHUA JAMES SACKET Master CIT SV \\'a0 M \\'a0 \\'a024.0 \\'a0jbond\\
    \\
    \\
    Total Number Of Students In Course \\'a096700 \\'a0Section \\'a0B \\'a0 is \\'a0 \\'a0 \\'a0 \\'a02\\
    }"
  end

  let(:rtf_file) { mock("foo.rtf") }

  let(:html_src) do
    # return some test html source code
  end

  let(:html_file_path) { mock("foo.html") }

  describe "#import_rtf" do
    describe "when source file is not found" do
      it "should raise Errno::ENOENT" do
        expect {
          HubStudentImporter.import_rtf("")
        }.should raise_error(Errno::ENOENT)
      end
    end

    describe "when source file is found" do
      describe "when given file with invalid RTF format" do
        it "should raise invalid RTF format error" do
          rtf_file.should_receive(:read).once.and_return("")
          File.should_receive(:open).once.with("foo.rtf", "r").and_yield(rtf_file)

          expect {
            HubStudentImporter.import_rtf("foo.rtf")
          }.should raise_error(RubyRTF::InvalidDocument)
        end
      end

      describe "when given valid RTF file" do
        let(:courses) do
          rtf_file.stub!(:read).once.and_return(rtf_src)
          File.stub!(:open).once.with("foo.rtf", "r").and_yield(rtf_file)

          HubStudentImporter.import_rtf("foo.rtf")
        end

        it "should return 2 courses" do
          courses.size.should == 2
        end

        it "should return the right number of instructors" do
          courses[0].instructors.size.should == 2
        end

        it "should parse the instructors correctly" do
          ["KATZ, E.", "SEDANO, A."].each do |instructor|
            courses[0].instructors.include?(instructor).should == true
          end
        end

        it "should return the right number of students" do
          courses[0].students.size.should == 1
          courses[1].students.size.should == 2
        end

        it "should return the right attributes for the student" do
          courses[0].students[0].last_name.should == "AGGARWAL"
          courses[0].students[0].first_name.should == "CHARU"
          courses[0].students[0].class.should == "Master"
          courses[0].students[0].college.should == "CIT"
          courses[0].students[0].department.should == "SV"
          courses[0].students[0].g_o.should == "M"
          courses[0].students[0].units.should == 24.0
          courses[0].students[0].user_id.should == "caggarwa"
        end
      end
    end
  end

  describe "#import_html" do
    describe "when source file is not found" do
	   it "should raise Errno::ENOENT" do
	      expect{
	         HubStudentImporter.import_html("erroneous_file.html")
	      }.should raise_error(Errno::ENOENT)
	   end
	end
	
	describe "when source file is found" do
      describe "when given file with valid HTML format" do
        describe "parsing the mfse class" do
          let(:courses) do
            HubStudentImporter.import_html(("./public/data_input_mfse_fall_2011.html"))
          end
        
          it "should return one course" do
            courses.length.should == 1
          end
          
          it "should have only one instructor" do
            courses[0].instructors.length.should == 1
            courses[0].instructors[0].should == "SEDANO, A."
          end
          
          it "should have twenty seven students" do
            courses[0].students.size().should == 27
          end
          
          it "should return the right attributes for the student Aaron James Cave" do
            courses[0].students[3].last_name.should == "CAVE"
            courses[0].students[3].first_name.should == "AARON JAMES"
            courses[0].students[3].class.should == "Master"
            courses[0].students[3].college.should == "CIT"
            courses[0].students[3].department.should == "SV"
            courses[0].students[3].g_o.should == "M"
            courses[0].students[3].units.should == 12.0
            courses[0].students[3].user_id.should == "acave"
          end
        end
    
        describe "parsing the foundations class" do
          let(:courses) do
            HubStudentImporter.import_html(File.expand_path("./public/data_input_foundations_fall_2011.html"))
          end
          
          it "should return two courses" do
            courses.length.should == 2
          end
          
          it "should have two instructors" do
            courses.each do |course|
              course.instructors.length.should == 2
            end
            courses[0].instructors[0].should == "SEDANO, A."
            courses[0].instructors[1].should == "KATZ, E."
          end
          
          it "should contain eighteen students" do
            courses[0].students.size().should == 18
            courses[1].students.size().should == 18
          end
          
          it "should find student located in section A only" do
            courses[0].students[0].last_name.should == "AGGARWAL"
            courses[0].students[0].first_name.should == "CHARU"
            courses[0].students[0].class.should == "Master"
            courses[0].students[0].college.should == "CIT"
            courses[0].students[0].department.should == "SV"
            courses[0].students[0].g_o.should == "M"
            courses[0].students[0].units.should == 24.0
            courses[0].students[0].user_id.should == "caggarwa"
          end
          
          it "should find student located in section B only" do
            courses[1].students[2].last_name.should == "BROWN"
            courses[1].students[2].first_name.should == "MORGAN H.G."
            courses[1].students[2].class.should == "Master"
            courses[1].students[2].college.should == "CIT"
            courses[1].students[2].department.should == "SV"
            courses[1].students[2].g_o.should == "M"
            courses[1].students[2].units.should == 24.0
            courses[1].students[2].user_id.should == "mhbrown"
          end
        end
      end
    end
  end
end

describe HubStudentImporter::Course do
  let(:course) { HubStudentImporter::Course.new }

  describe "regex patterns" do
    describe "::META_COURSE_HEADER_MATCHER" do
      it "should match CLASS with padding space" do
        "                CLASS ".should match(HubStudentImporter::Course::META_COURSE_HEADER_MATCHER)
      end

      it "should not match class in lower case" do
        "                class ".should_not match(HubStudentImporter::Course::META_COURSE_HEADER_MATCHER)
      end
    end

    describe "::META_DATA_LINE1_MATCHER" do
      it "should match valid course line 1 info" do
        course_info_line = "Run Date: 18-jul-2011   Course: 96700 Sect: A  FOUNDATNS SW ENG"
        course_info_line.should match(HubStudentImporter::Course::META_DATA_LINE1_MATCHER)
      end

      it "should match valid course line 1 info with multi-char section number" do
        course_info_line = "Run Date: 18-jul-2011   Course: 96700 Sect: A1  FOUNDATNS SW ENG"
        course_info_line.should match(HubStudentImporter::Course::META_DATA_LINE1_MATCHER)
      end

      it "should not match invalid course line 1 info" do
        course_info_line = "Run Date: 18-jul-2011   Course: 96700 Sect: A  "
        course_info_line.should match(HubStudentImporter::Course::META_DATA_LINE1_MATCHER)
      end
    end

    describe "::META_DATA_LINE2_MATCHER" do
      it "should match valid course line 2 info" do
        "Semester: F11       College: CIT Department: SV".should match(HubStudentImporter::Course::META_DATA_LINE2_MATCHER)
      end

      it "should not match invalid course line 2 info with missing semester" do
        ": F11       College: CIT Department: SV".should_not match(HubStudentImporter::Course::META_DATA_LINE2_MATCHER)
      end
    end

    describe "::META_INSTRUCTOR_MATCHER" do
      it "should match simple instructor name" do
        "             Instructor(s): SEDANO, A.".should match(HubStudentImporter::Course::META_INSTRUCTOR_MATCHER)
      end
      
      it "should match instructor name with '-' in last name" do
        "             Instructor(s): Foo-Bar, A.".should match(HubStudentImporter::Course::META_INSTRUCTOR_MATCHER)
      end
      
      it "should match instructor name with space in last name" do
        "             Instructor(s): Foo Bar, A.".should match(HubStudentImporter::Course::META_INSTRUCTOR_MATCHER)
      end

      it "should match instructor name with first and middle name initials" do
        "             Instructor(s): Baz, F. B.".should match(HubStudentImporter::Course::META_INSTRUCTOR_MATCHER)
      end
    end

    describe "::META_INSTRUCTOR_NAME_MATCHER" do
      it "should match simple instructor name" do
        "                    KATZ, E.".should match(HubStudentImporter::Course::META_INSTRUCTOR_NAME_MATCHER)
      end
      
      it "should match instructor name with '-' in last name" do
        "                    Foo-Bar, E.".should match(HubStudentImporter::Course::META_INSTRUCTOR_NAME_MATCHER)
      end
      
      it "should match instructor name with space in last name" do
        "                    Foo Bar, E.".should match(HubStudentImporter::Course::META_INSTRUCTOR_NAME_MATCHER)
      end

      it "should match instructor name with first and middle name initials" do
        "                    Baz, F.B.".should match(HubStudentImporter::Course::META_INSTRUCTOR_NAME_MATCHER)
      end

    end

    describe "::META_TOTAL_STUDENTS_MATCHER" do
      it "should match valid total students line" do
        total_students_line = "Total Number Of Students In Course 96700 Section A  is    21"
        total_students_line.should match(HubStudentImporter::Course::META_TOTAL_STUDENTS_MATCHER)
      end

      it "should match valid total students line with multi-char section name" do
        total_students_line = "Total Number Of Students In Course 96700 Section A1  is    21"
        total_students_line.should match(HubStudentImporter::Course::META_TOTAL_STUDENTS_MATCHER)
      end
    end
  end
end

describe HubStudentImporter::Student do
  let(:student) { HubStudentImporter::Student.new }

  def student_record_string(name)
    "#{name}      Master CIT SV  M  24.0 foobar"
  end

  describe "regex patterns" do
    describe "::META_STUDENT_INFO_MATCHER" do
      it "should not match empty string" do
        "".should_not match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should not match invalid string" do
        "asdfas asdfa aiiaidif foo bar 24a dsfasdf 11".should_not match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should match students with simple first last name" do
        student_record_string("bar, foo").should match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should match students with '-' in their last names" do
        student_record_string("bar-baz, foo").should match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should match students with '-' in their first names" do
        student_record_string("baz, foo-bar").should match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should match students with middle names" do
        student_record_string("baz, foo bar").should match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end

      it "should match students with first name of 3+ words" do
        student_record_string("qux, foo bar baz").should match(HubStudentImporter::Student::META_STUDENT_INFO_MATCHER)
      end
    end
  end
end

