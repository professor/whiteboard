require 'ruby-rtf'
require 'nokogiri'

module HubStudentImporter
  extend self

  # Weird multibyte characters in RTF
  RTF_MULTIBYTE_MATCHER = Regexp.new('[\xA0-\xDF]', nil, 'n')

  def import_rtf(src_file_path)
    rtf_source = File.open(src_file_path, "r") { |f| f.read }
    parser = RubyRTF::Parser.new
    document_hash = parser.parse(rtf_source)

    courses = []
    course = Course.new

    document_hash.sections.each do |section|
      # first clean up the text
      text = section[:text].gsub(RTF_MULTIBYTE_MATCHER, "")

      # Parsing course data with regex magic
      # The initial check on course object attributes is 
      # meant for optimization so we don't run uncessary
      unless text.match(Course::META_COURSE_HEADER_MATCHER)
        if text.match(Course::META_DATA_LINE1_MATCHER)
          course.run_date = Time.parse($1)
          course.number = $2
          course.section = $3
          course.name = $4
        elsif text.match(Course::META_DATA_LINE2_MATCHER)
          course.semester = $1
          course.college = $2
          course.department = $3
        elsif text.match(Course::META_INSTRUCTOR_MATCHER)
          course.instructors << $1
        elsif text.match(Course::META_INSTRUCTOR_NAME_MATCHER)
          course.instructors << $1
        elsif text.match(Student::META_STUDENT_INFO_MATCHER)
            first_name, last_name = $1.split(", ")
            course.students << Student.new({ :first_name => first_name.strip, :last_name => last_name.strip, :class => $2, :college => $3, :department => $4, :g_o => $5, :units => $6, :user_id => $7})
        elsif text.match(Course::META_TOTAL_STUDENTS_MATCHER)
          course.total_students = $1.to_i
        else
          # ignore junk
        end
      else
        course = Course.new
        courses << course
      end
    end

    courses
  end

  #Similar logic flow for RTF parsing but for HTML instead
  def import_html(src_file_path)
    # Open file from src_file_path
    # create the HTML parser from Nokogiri
    # close the file stream
      html_file = File.open(src_file_path)
   html_parser = Nokogiri::HTML(html_file)
   html_file.close()

   #define regular expression variables here;  These may be removed upon verification of logic used for RTF (leveraged RTF logic for HTML)
  # time = Regexp.new(/Run Date: \d{2}-\w+-\d{4}/)
  # course = Regexp.new(/Course: \d+/)
  # section = Regexp.new(/Sect: \w/)
  # semester = Regexp.new(/Semester: \w+/)
  # college = Regexp.new(/College: \w+/)
  # department = Regexp.new(/Department: .*/)
   
   courses = []
   course = Course.new
   
   # time_stripped = <line>.match(time).to_s.gsub("Run Date: ","").strip
   # course_stripped = <line>.match(course).to_s.gsub("Course: ","").strip
   # section_part = string_array[2].match(section).to_s.gsub("Sect: ","").strip
   # section_name = string_array[2].match(/\w+\s\w+\s\w+/).to_s
   # string_array[3].match(/Semester: \w+/).to_s.gsub("Semester: ","").strip
   # string_array[3].match(/Department: .*/).to_s.gsub("Department: ","").strip
   # string_array[4].gsub("Instructor(s): ","").match(/\w+, .*/)
   #  string_array[6].match(/^\s*Name/) - Determines which column is right before the students
   #  string_array[10].match(/\w+\s?\w*, \w+\s?[a-zA-z|\.]*/).strip - for last name, first name
   
   # Parse the html file by the tag <pre> and loop per tag (the HTML contents that we care about are surrounded in <pre> tags.
   # In the case where a multi-set HTML document exists (e.g. Foundations has a A section and a B section), the <pre> tags easily
   # distinguish which Semester portion the students are registered for.
   
   search_parser = html_parser.search("//pre")
   search_parser.each do |search_section|
   
   # split the file by newline character to access data line by line
      file_array = search_section.to_s.split(/\n+/)
      file_array.each_with_index do |string_line, i|
    
      unless string_line.match(Course::META_COURSE_HEADER_MATCHER)
        if string_line.match(Course::META_DATA_LINE1_MATCHER)
          course.run_date = Time.parse($1)
          course.number = $2
          course.section = $3
          course.name = $4
        elsif string_line.match(Course::META_DATA_LINE2_MATCHER)
          course.semester = $1
          course.college = $2
          course.department = $3
        elsif string_line.match(Course::META_INSTRUCTOR_MATCHER)
          course.instructors << $1
        elsif string_line.match(Course::META_INSTRUCTOR_NAME_MATCHER)
          course.instructors << $1
        elsif string_line.match(Student::META_STUDENT_INFO_MATCHER)
          first_name, last_name = $1.split(", ")
          course.students << Student.new({ :first_name => first_name.strip, :last_name => last_name.strip, :class => $2, :college => $3, :department => $4, :g_o => $5, :units => $6, :user_id => $7})
        elsif string_line.match(Course::META_TOTAL_STUDENTS_MATCHER)
          course.total_students = $1.to_i
        else
          # ignore junk
        end
      else
        course = Course.new
        courses << course
      end
    end
   end
  end

  private

  # Should refactor Course and Student into its
  # own class file and require this in the importer
  class Course
    attr_accessor :run_date, :semester, :number, :section, :name, :college, :department, :instructors, :students, :total_students

    META_COURSE_HEADER_MATCHER = /\s+CLASS\s$/
    META_DATA_LINE1_MATCHER = /^Run Date: (\d{2}-\w+-\d{4})\s+Course: (\d+) Sect: (\w+)\s+(.*)$/
    META_DATA_LINE2_MATCHER = /^Semester: (\w+)\s+College: (\w+) Department: (\w+).*$/
    META_INSTRUCTOR_MATCHER = /^\s+Instructor\(s\): (.*)$/
    META_INSTRUCTOR_NAME_MATCHER = /(\S+, \S+)$/
    META_TOTAL_STUDENTS_MATCHER = /^Total Number Of Students In Course.*is\s+(\d+)$/

    def initialize(opts={})
      options = { :instructors => [], :students => [], :total_students => 0 }.merge(opts)
      options.each do |attr, val|
        send("#{attr}=".to_sym, val)
      end

      super(options)
    end
  end

  class Student
    attr_accessor :first_name, :last_name, :class, :college, :department, :g_o, :user_id, :units

    META_STUDENT_INFO_MATCHER = /^(.+, .+)\s+(\w+) (\w+) (\w+)\s+(\w+)\s+(\d+\.\d) (\w+).*$/

    def initialize(opts={})
      opts.each do |attr, val|
        send("#{attr}=".to_sym, val)
      end

      super(opts)
    end

    def full_name
      "#{first_name} #{last_name}"
    end
  end
end
