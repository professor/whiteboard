class Page < ActiveRecord::Base
    validates_presence_of :title
    validates_presence_of :updated_by_user_id

#    acts_as_versioned  :table_name => 'page_versions'

    belongs_to :course
    acts_as_list :scope => :course

  def before_save
     self.updated_by_user_id = current_user.id if current_user      
  end

  def editable?
    return (current_user.is_staff? || current_user.is_admin?)
  end

end
