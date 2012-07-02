FactoryGirl.define do

factory :page_attachment, :class => PageAttachment do |pa|
  pa.page_attachment_file_name 'booo.jpg'
  pa.page_attachment_content_type 'image/jpg'
  pa.page_attachment_file_size 3231
#  pa.association :user, :factory => :faculty_frank
  pa.readable_name 'Booo'
end

factory :blank_page_attachment, :class => PageAttachment do |pa|
  pa.page_attachment_file_name ''
  pa.page_attachment_content_type ''
  pa.page_attachment_file_size 0
  pa.readable_name ''
end

end
