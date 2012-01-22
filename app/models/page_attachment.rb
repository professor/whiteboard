class PageAttachment < ActiveRecord::Base
  belongs_to :page
  has_attached_file :page_attachment,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "page_attachments/:id/:filename"
end
