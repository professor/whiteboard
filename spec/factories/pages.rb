require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :ppm, :parent => :page  do |p|
  p.title "Syllabus"
  p.url "ppm"
  p.updated_by_user_id 10
  p.tab_one_contents "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering."
end

Factory.define :page_with_attachment, :parent => :page do |p|
  p.title "Syllabus"
  p.url "page_with_attachment"
  p.updated_by_user_id 10
  p.tab_one_contents "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering."
  p.after_create { |p| PageAttachment.create!(:page_id => p.id, :owner_id => Factory(:admin_andy).id, :attachment_file_name => "foobar.txt") }

end

