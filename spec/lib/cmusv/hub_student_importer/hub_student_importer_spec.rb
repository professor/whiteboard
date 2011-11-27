require 'spec_helper'
require File.join(File.dirname(__FILE__), "../../../../lib/cmusv/hub_student_importer/hub_student_importer")

describe HubStudentImporter do
  let(:rtf_src) do
    # return some test rtf source code
    "{\rtf1\ansi\ansicpg1252\cocoartf1138\cocoasubrtf230
    {\fonttbl\f0\fswiss\fcharset0 ArialMT;}
    {\colortbl;\red255\green255\blue255;\red26\green26\blue26;\red255\green252\blue125;}
    \margl1440\margr1440\vieww27540\viewh16600\viewkind0
    \deftab720
    \pard\pardeftab720

    \f0\fs26 \cf0 \
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0CLASS \cf2 \cb3 ROSTER\cf0 \cb1 \
    \
    Run Date: 18-jul-2011 \'a0 \'a0 \'a0Course: 96700 \'a0Sect: A \'a0 FOUNDATNS SW ENG\
    Semester: F11 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0College: \'a0CIT \'a0Department: \'a0SV\
    \
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 Instructor(s): SEDANO, A.\
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0KATZ, E.\
    \
    Name \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0Class \'a0Col Dept G/O \'a0Units UserID \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 Mid Fin Def\
    _______________________________________________________________________________________\
    \
    AGGARWAL, CHARU \'a0 \'a0 \'a0 \'a0 \'a0 Master CIT SV \'a0 M \'a0 \'a024.0 \'a0caggarwa\
    \
    \
    Total Number Of Students In Course \'a096700 \'a0Section \'a0A \'a0 is \'a0 \'a0 \'a0 \'a01\
    \
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0CLASS \cf2 \cb3 ROSTER\cf0 \cb1 \
    \
    Run Date: 18-jul-2011 \'a0 \'a0 \'a0Course: 96700 \'a0Sect: B \'a0 FOUNDATNS SW ENG\
    Semester: F11 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0College: \'a0CIT \'a0Department: \'a0SV\
    \
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 Instructor(s): SEDANO, A.\
    \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0KATZ, E.\
    \
    Name \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0Class \'a0Col Dept G/O \'a0Units UserID \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 Mid Fin Def\
    _______________________________________________________________________________________\
    \
    BAILEY, BRIAN \'a0 \'a0 \'a0 \'a0 \'a0 \'a0 Master CIT SV \'a0 M \'a0 \'a024.0 \'a0brianbai\
    \
    BOND, JOSHUA JAMES SACKET Master CIT SV \'a0 M \'a0 \'a024.0 \'a0jbond\
    \
    \
    Total Number Of Students In Course \'a096700 \'a0Section \'a0B \'a0 is \'a0 \'a0 \'a0 \'a02\
    }"
  end

  let(:rtf_file) { mock("foo.rtf") }

  let(:html_src) do
    # return some test html source code
  end

  let(:html_file) { mock("foo.html") }

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
        it "should ..." do
          
        end
      end
    end
  end

  describe "#import_html" do
    
  end
end

describe HubStudentImporter::Course do
  let(:course) { HubStudentImporter::Course.new }

  describe "regex patterns" do
    describe "::META_COURSE_HEADER_MATCHER" do
      
    end

    describe "::META_DATA_LINE1_MATCHER" do

    end

    describe "::META_DATA_LINE2_MATCHER" do
      
    end

    describe "::META_INSTRUCTOR_MATCHER" do
      
    end

    describe "::META_INSTRUCTOR_NAME_MATCHER" do
    end
  end

    describe "::META_TOTAL_STUDENTS_MATCHER" do
    end
  end
end

describe HubStudentImporter::Student do
  let(:student) { HubStudentImporter::Student.new }
end

