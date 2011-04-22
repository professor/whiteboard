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

Paperclip.interpolates('deliverable_course_name') do |attachment, style|
  attachment.instance.deliverable.course.display_course_name
end

Paperclip.interpolates('course_year') do |attachment, style|
  attachment.instance.course.year
end

Paperclip.interpolates('deliverable_course_year') do |attachment, style|
  attachment.instance.deliverable.course.year
end