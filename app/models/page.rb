class Page < ActiveRecord::Base
    attr_accessible :course_id, :title, :position, :identation_levels, :is_task, :tab_one_contents, :tab_two_contents,
                    :tab_three_contents, :task_duration, :tab_one_email_from, :tab_one_email_subject, :tips_and_traps, :faculty_notes,
                    :url, :is_editable_by_all, :version_comments, :course_name

    versioned

    validates_presence_of :title
    validates_presence_of :updated_by_user_id
    validates_uniqueness_of :url, :allow_blank => true
    validates_format_of :url, :allow_blank => true, :message => "can not be a number", :with => /^.*\D+.*$/ #it can not be a number

    belongs_to :updated_by, :class_name=>'User', :foreign_key => 'updated_by_user_id'

    belongs_to :course
    acts_as_list :scope => :course

    before_validation :update_user_and_url

  def editable?(current_user)    
    return false if self.is_duplicated_page? 
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
  #if database is mysql
#    update_all(
#      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
#      { :id => ids }
#    )
     update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], { :id => ids })
 end             

  def course_name
    self.course.nil? ? nil : self.course.name
  end

  def course_name=(course_name)
    course = Course.first_offering_for_course_name(course_name)
    self.course = course
  end


 def task_number  
    match = self.title.match /\d/
    match.nil? ? nil : match[0]
 end 

  protected
  def update_user_and_url
      current_user = UserSession.find.user
     self.updated_by_user_id = current_user.id if current_user
     self.url = self.title if self.url.blank?
  end

end
