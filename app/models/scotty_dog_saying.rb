class ScottyDogSaying < ActiveRecord::Base
  belongs_to :user, :class_name=>"Person", :foreign_key=>"user_id"

  validates_presence_of :saying, :user_id

  def editable(current_user)
    if (current_user && current_user.is_admin?)
      return true
    end
    if (current_user && current_user.id == user_id)
      return true
    end
    return false
  end

end
