require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :ppm, :parent => :page  do |p|
  p.title "Syllabus"
  p.url "ppm"
  p.updated_by_user_id 10
  p.tab_one_contents "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering."
end

