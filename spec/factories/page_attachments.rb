FactoryGirl.define do

  factory :page_attachment, :class => PageAttachment do
    page_attachment_file_name 'booo.jpg'
    page_attachment_content_type 'image/jpg'
    page_attachment_file_size 3231
#  association :user, :factory => :faculty_frank
    readable_name 'Booo'
  end

  factory :blank_page_attachment, :class => PageAttachment do
    page_attachment_file_name ''
    page_attachment_content_type ''
    page_attachment_file_size 0
    readable_name ''
  end

end
