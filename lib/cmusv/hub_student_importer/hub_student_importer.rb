require 'ruby-rtf'

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
      if course.current_parse_step == Course::PARSE_STEPS[0] && text.match(Course::META_DATA_LINE1_MATCHER)
        course.run_date = Time.parse($1)
        course.number = $2
        course.section = $3
        course.name = $4

        course.update_parse_step!
      elsif course.current_parse_step == Course::PARSE_STEPS[1] && text.match(Course::META_DATA_LINE2_MATCHER)
        course.semester = $1
        course.college = $2
        course.department = $3

        course.update_parse_step!
      elsif course.current_parse_step == Course::PARSE_STEPS[2] && text.match(Course::META_INSTRUCTOR_MATCHER)
        course.instructors << $1
      elsif course.current_parse_step == Course::PARSE_STEPS[2] && text.match(Course::META_INSTRUCTOR_NAME_MATCHER)
        course.instructors << $1

        course.update_parse_step!
      elsif course.current_parse_step == Course::PARSE_STEPS[3] && text.match(Student::META_STUDENT_INFO_MATCHER)
          first_name, last_name = $1.split(", ")
          course.students << Student.new({ :first_name => first_name, :last_name => last_name, :class => $2, :college => $3, :department => $4, :g_o => $5, :units => $6, :user_id => $7})
      elsif course.current_parse_step == Course::PARSE_STEPS[3] && text.match(Course::META_TOTAL_STUDENTS_MATCHER)
        course.update_parse_step!

        course.total_students = $1.to_i

        course.update_parse_step!
      # elsif course.current_parse_step != Course::PARSE_STEPS[0] && text.match(Course::META_COURSE_HEADER_MATCHER)
      #   # it should never reach here unless the file 
      #   # was not properly formatted
      #   courses << course
      #   course = Course.new
      elsif course.current_parse_step == Course::PARSE_STEPS.values.last
        courses << course
        course = Course.new
      else
        # ignore junk
      end
    end

    courses
  end

  def import_html(src_file_path)
  end

  private

  # Should refactor Course and Student into its
  # own class file and require this in the importer
  class Course
    attr_accessor :run_date, :semester, :number, :section, :name, :college, :department, :instructors, :students, :total_students

    META_COURSE_HEADER_MATCHER = /\s+CLASS\s$/
    META_DATA_LINE1_MATCHER = /^Run Date: (\d{2}-\w+-\d{4})\s+Course: (\d+) Sect: (\w)\s+(.*)$/
    META_DATA_LINE2_MATCHER = /^Semester: (\w+)\s+College: (\w+) Department: (\w+).*$/
    META_INSTRUCTOR_MATCHER = /^\s+Instructor\(s\): (.*)$/
    META_INSTRUCTOR_NAME_MATCHER = /(\w+, \w+.)$/
    META_TOTAL_STUDENTS_MATCHER = /^Total Number Of Students In Course.*is\s+(\d+)$/

    PARSE_STEPS = {
      0 => :meta_info_line1,
      1 => :meta_info_line2,
      2 => :instructors,
      3 => :students,
      4 => :total_students,
      5 => :done
    }

    def initialize(opts={})
      options = { :instructors => [], :students => [], :total_students => 0 }.merge(opts)
      options.each do |attr, val|
        send("#{attr}=".to_sym, val)
      end

      @parse_step = 0

      super(options)
    end

    def update_parse_step!
      # look up different attributes of course object and
      # update + return the new step
      @parse_step = [@parse_step + 1, PARSE_STEPS.keys.max].min
    end

    def current_parse_step
      PARSE_STEPS[@parse_step]
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
