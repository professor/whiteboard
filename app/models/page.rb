class Page < ActiveRecord::Base
    attr_accessible :course_id, :title, :position, :identation_levels, :is_task, :tab_one_contents, :tab_two_contents,
                    :tab_three_contents, :task_duration, :tab_one_email_from, :tab_one_email_subject, :tips_and_traps, :faculty_notes,
                    :url, :is_editable_by_all, :version_comments

    versioned

    validates_presence_of :title
    validates_presence_of :updated_by_user_id
    validates_uniqueness_of :url, :allow_blank => true
    validates_format_of :url, :allow_blank => true, :message => "can not be a number", :with => /^.*\D+.*$/ #it can not be a number

    belongs_to :updated_by, :class_name=>'User', :foreign_key => 'updated_by_user_id'

    belongs_to :course
    acts_as_list :scope => :course

  def before_validation
      current_user = UserSession.find.user
     self.updated_by_user_id = current_user.id if current_user
     self.url = self.title if self.url.blank?
  end

  def editable?(current_user)
    return true if self.is_editable_by_all?
    return (current_user.is_staff? || current_user.is_admin?)
  end


  def to_param
    url
  end
#  def to_param
#    if url.blank?
#      id.to_s
#    else
#      url
#    end
#  end


 #Re-position: change the sequence of pages for a given course
 def self.reposition(ids)
  if Rails.env.development?
    update_all(
      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  else
     update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], { :id => ids })     
  end
 end

end
