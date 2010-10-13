class Page < ActiveRecord::Base
    validates_presence_of :title
    validates_presence_of :updated_by_user_id

#    acts_as_versioned  :table_name => 'page_versions'

    belongs_to :course
    acts_as_list :scope => :course

  def before_validation
      current_user = UserSession.find.user
     self.updated_by_user_id = current_user if current_user
  end

  def editable?(current_user)
#    current_user = UserSession.find.user
    return (current_user.is_staff? || current_user.is_admin?)
  end

end
