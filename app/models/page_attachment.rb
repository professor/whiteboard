#
# Any user who can edit a {Page}[link:classes/Page.html] can also upload attachments to that page.
# (Note: in this system a Page is the CMS pages that represent curriculum materials. A user can not
# upload an attachment to a team or a person page through this code.)
#
# The attachments are stored on Amazon S3. S3 allows us to revision all documents. All old versions
# are still stored on the filesystem even though the user can only actively access the latest one.
#
# When uploading a file, the user is asked for a "readable name" for the file: a label for the link
# to the file.
#
# After uploading a file, the file's "readable name" can be updated or the file can be replaced.
# If the user replaces the an existing file (e.g. 'ppm_week1.ppt') with a different file name
# (e.g. 'ppm_week1_ts.ppt') then a warning appears. Any user who tries to access the original file
# name will not be able to do so. Under normal workflow, this isn't a big deal. It is possible
# for the user to create a link on the page to the old file and system will not automatically
# update it.
#
# The system records who uploads and replaces the file and when this happens, and versions this information.
#

class PageAttachment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user

  validates_presence_of :readable_name, :user_id, :page_id

  has_attached_file :page_attachment,
                    :storage => :s3,
                    :bucket => ENV['WHITEBOARD_S3_BUCKET'],
                    :s3_credentials => {:access_key_id => ENV['WHITEBOARD_S3_KEY'],
                                        :secret_access_key => ENV['WHITEBOARD_S3_SECRET']},
                    :path => "page_attachments/:page_id/:random_hash/:id/:filename"

  versioned

  #Re-position: change the sequence of attachments for a given page
  def self.reposition(ids)
    update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], {:id => ids})
  end

end
