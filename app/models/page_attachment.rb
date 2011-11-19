class PageAttachment < ActiveRecord::Base
 belongs_to :owner, :class_name => "Person", :foreign_key => "owner_id"
 belongs_to :page

 # (RDL 11/17/2011) s3 paperclip initializer may need to be considered to get s3 upload to work
 # properly (see deliverable_attachment.rb)
 has_attached_file :attachment,
                   :storage => :s3,
                   :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                   :path => "page_attachments/:id/:filename"

  validates_presence_of :owner

end
