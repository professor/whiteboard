class PageAttachment < ActiveRecord::Base

belongs_to :page

  has_attached_file :attachment,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "pages/:page_course_year/:page_course_name/:page_random_hash/submissions/:id/:filename"

end
