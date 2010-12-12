Factory.define :person, :class => Person do |p|
  p.is_staff 0
  p.is_student 0
  p.is_admin 0
  p.is_teacher 0
  p.is_active 1
  p.image_uri "/images/mascot.jpg"
end


Factory.define :admin_andy, :class => Person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.login "admin_andy"
  p.email "andy@andrew.cmu.edu"
  p.is_staff true
  p.is_admin true
  p.first_name "Admin"
  p.last_name "Andy"
  p.human_name "Admin Andy"
end

Factory.define :student_sam, :class => Person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.login "student_sam"
  p.email "sam@andrew.cmu.edu"
  p.is_student true
  p.is_alumnus false
  p.first_name "Student"
  p.last_name "Sam"
  p.human_name "Student Sam"
end

Factory.define :faculty_frank, :class => Person do |p|
  p.login "faculty_frank"
  p.email "frank@andrew.cmu.edu"
  p.is_staff true
  p.is_teacher true
  p.first_name "Faculty"
  p.last_name "Frank"
  p.human_name "Faculty Frank"
end