class Page < ActiveRecord::Base
    validates_presence_of :title
    validates_presence_of :updated_by_user_id

    belongs_to :updated_by, :class_name=>'User', :foreign_key => 'updated_by_user_id'

#    acts_as_versioned  :table_name => 'page_versions'

    belongs_to :course
    acts_as_list :scope => :course

  def before_validation
      current_user = UserSession.find.user
     self.updated_by_user_id = current_user.id if current_user
  end

  def editable?(current_user)
#    current_user = UserSession.find.user
    return (current_user.is_staff? || current_user.is_admin?)
  end


 #Re-position: change the sequence of pages for a given course
 def self.reposition(ids)
  if (ENV['RAILS_ENV']=='development') #development?
    update_all(
      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  else
     update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], { :id => ids })     
  end

 end

end
