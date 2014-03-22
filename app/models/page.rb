class Page < ActiveRecord::Base
  attr_accessible :course_id, :title, :position, :indentation_level, :is_task, :tab_one_contents, :tab_two_contents,
                  :tab_three_contents, :task_duration, :tab_one_email_from, :tab_one_email_subject, :tips_and_traps, :faculty_notes,
                  :url, :is_editable_by_all, :is_viewable_by_all, :viewable_by, :version_comments, :course_name

  versioned

  validates_presence_of :title
  validates_presence_of :updated_by_user_id
  validates_uniqueness_of :url, :allow_blank => true
  validates_format_of :url, :allow_blank => true, :message => "can not be a number", :with => /^.*\D+.*$/ #it can not be a number

  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by_user_id'
  belongs_to :current_edit_by, :class_name => 'User', :foreign_key => 'current_edit_by_user_id'

  has_many :page_attachments, :order => "position"
  belongs_to :course
  acts_as_list :scope => :course

  before_validation :update_url

  after_save :update_search_index
  before_destroy :delete_from_search

  def editable?(current_user)
    return false if self.is_duplicated_page?
    return false if current_user.blank?
    return true if self.is_editable_by_all?
    return (current_user.is_staff? || current_user.is_admin?)
  end

  def viewable?(current_user)
    return true if self.viewable_by == "world"
    return false if current_user.blank?
    if self.viewable_by == "users"
      return current_user.present?
    else
      return (current_user.is_staff? || current_user.is_admin?)
    end
  end

  def to_param
    url
  end


  #Re-position: change the sequence of pages for a given course
  def self.reposition(ids)
    #if database is mysql
    #    update_all(
    #      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
    #      { :id => ids }
    #    )
    update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], {:id => ids})
  end

  def course_name
    self.course.nil? ? nil : self.course.name
  end

  def course_name=(course_name)
    course = Course.first_offering_for_course_name(course_name)
    self.course = course
  end


  def task_number
    match = self.title.match /\d+/
    match.nil? ? nil : match[0]
  end

  def update_search_index
    if self.viewable_by == "staff"
      update_search_index_for_index(ENV['WHITEBOARD_SEARCHIFY_STAFF_INDEX'] || 'cmu_staffx')
    else
      update_search_index_for_index(ENV['WHITEBOARD_SEARCHIFY_INDEX'] || 'cmux')
    end
  end

  def update_search_index_for_index(index_name)
    api = IndexTank::Client.new(ENV['WHITEBOARD_SEARCHIFY_API_URL'] || '<API_URL>')
    index = api.indexes(index_name)
    options_hash = {:title => self.title, :type => "page"}
    if self.course
      options_hash.merge!({:title => self.title + " (" + self.course.name + ")"})
    end

    begin
      index.document(self.id.to_s).add(options_hash.merge!({:text => self.tab_one_contents.gsub(/<\/?[^>]*>/, ""), :url => "pages/" + self.url}))
      if self.is_task?
        index.document(self.id.to_s + "-tabs-1").add(options_hash.merge!({:text => self.tab_two_contents.gsub(/<\/?[^>]*>/, ""), :url => "pages/" + self.url + "?tab=tabs-2"}))
        index.document(self.id.to_s + "-tabs-2").add(options_hash.merge!({:text => self.tab_three_contents.gsub(/<\/?[^>]*>/, ""), :url => "pages/" + self.url + "?tab=tabs-3"}))
      end
    rescue Exception => e
      logger.error("Searchify issue: " + e.message)
    end
  end

  def delete_from_search
    api = IndexTank::Client.new(ENV['WHITEBOARD_SEARCHIFY_API_URL'] || '<API_URL>')
    index = api.indexes(ENV['WHITEBOARD_SEARCHIFY_INDEX'] || 'cmux')
    index.document(self.id.to_s).delete
  end

  def current_semester_course
    #This little bit of magic finds the current offering of a course. This is handy for deliverable submission
    #and team lists where the static curriculum website points to the latest offering of the course.
    unless self.course.blank? || self.course.number.blank?
      Course.in_current_semester_with_course_number(self.course.number).first
    else
      nil
    end
  end


  def is_someone_else_currently_editing_page(current_user)
    self.current_edit_by != current_user
  end

  def timeout_has_not_passed
    if self.current_edit_started_at.nil?
      false
    else
      Time.now - self.current_edit_started_at < 5.minute
    end
  end

  protected
  def update_url
    self.url = self.title if self.url.blank?
  end

end
