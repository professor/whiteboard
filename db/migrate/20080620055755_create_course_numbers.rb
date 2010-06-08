class CreateCourseNumbers < ActiveRecord::Migration
  def self.up
    create_table :course_numbers do |t|
      t.string :name
      t.string :number
      t.timestamps     
    end    
    
    CourseNumber.create :number => "96-700", :name => "Foundations of Software Engineering I"
    CourseNumber.create :number => "96-701", :name => "Foundations of Software Engineering II"
    CourseNumber.create :number => "96-702", :name => "Requirements Engineering I"
    CourseNumber.create :number => "96-703", :name => "Metrics for Software Engineers"
    CourseNumber.create :number => "96-704", :name => "Requirements Engineering II"
    CourseNumber.create :number => "96-705", :name => "Architecture and Design I"
    CourseNumber.create :number => "96-706", :name => "Architecture and Design II"
    CourseNumber.create :number => "96-707", :name => "Construction I"
    CourseNumber.create :number => "96-708", :name => "Construction II"
    CourseNumber.create :number => "96-709", :name => "Avoiding Project Failures"
    CourseNumber.create :number => "96-710", :name => "Software Engineering Practicum I"
    CourseNumber.create :number => "96-711", :name => "Software Engineering Practicum II"
    CourseNumber.create :number => "96-780", :name => "Elements of Software Management"
    CourseNumber.create :number => "96-781", :name => "Metrics for Software Managers"
    CourseNumber.create :number => "96-782", :name => "Project and Process Management"
    CourseNumber.create :number => "96-783", :name => "Managing Software Professionals"
    CourseNumber.create :number => "96-784", :name => "Managing Outsourced Development Elective I"
    CourseNumber.create :number => "96-785", :name => "Managing Outsourced Development II"
    CourseNumber.create :number => "96-786", :name => "Introduction to Open Source"
    CourseNumber.create :number => "96-788", :name => "Product Definition"
    CourseNumber.create :number => "96-789", :name => "Requirements Analysis"
    CourseNumber.create :number => "96-790", :name => "Software Product Strategy"
    CourseNumber.create :number => "96-791", :name => "The Business of Software"
    CourseNumber.create :number => "96-794", :name => "Practicum I"
    CourseNumber.create :number => "96-795", :name => "Practicum II"
    CourseNumber.create :number => "96-796", :name => "Human-Computer Interaction"
    CourseNumber.create :number => "96-805", :name => "Architecture and Design II"
    CourseNumber.create :number => "96-818", :name => "Innovation and Entrepreneurship"
    CourseNumber.create :number => "96-819", :name => "Entrepreneurial Finance"
    CourseNumber.create :number => "96-820", :name => "Product Management"
    CourseNumber.create :number => "96-821", :name => "Introduction to Software Engineering" 
  end

  def self.down
    drop_table :course_numbers 
  end
end
