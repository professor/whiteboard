class PageComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :type, :class_name => "PageCommentType", :foreign_key => "page_comment_type_id"
  belongs_to :page

  validates_presence_of :comment
  validates_presence_of :user_id

  def editable?(current_user)
    if (current_user && current_user.is_admin?)
      return true
    end
    if (current_user && current_user.id == user_id)
      return true
    end
    return false

  end

  def notify_us()
#todo add current
    curriculum_comments = PageComment.where(:page_id => self.page_id, :notify_me => true).all
    email_addresses = []
    curriculum_comments.each { |comment| email_addesses << comment.user.email }
    return email_addresses
  end

end