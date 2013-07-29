require 'digest/md5'

Paperclip.interpolates('random_hash') do |attachment, style|
  Digest::MD5.hexdigest(attachment.instance.id.to_s)
end

Paperclip.interpolates('deliverable_random_hash') do |attachment, style|
  Digest::MD5.hexdigest(attachment.instance.deliverable.id.to_s)
end

Paperclip.interpolates('course_name') do |attachment, style|
  attachment.instance.course.display_course_name
end

Paperclip.interpolates('course_year') do |attachment, style|
  attachment.instance.course.year
end

Paperclip.interpolates('deliverable_assignment_name') do |attachment, style|
  attachment.instance.deliverable.assignment.name
end

Paperclip.interpolates('deliverable_course_name') do |attachment, style|
  attachment.instance.deliverable.course.display_course_name
end

Paperclip.interpolates('deliverable_course_semester') do |attachment, style|
  attachment.instance.deliverable.course.semester
end

Paperclip.interpolates('deliverable_course_year') do |attachment, style|
  attachment.instance.deliverable.course.year
end

Paperclip.interpolates('deliverable_owner_name') do |attachment, style|
  attachment.instance.deliverable.owner_name_for_filename.parameterize.gsub('-', '_')

end


Paperclip.interpolates('page_id') do |attachment, style|
  attachment.instance.page.id
end