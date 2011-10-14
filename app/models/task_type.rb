class TaskType < ActiveRecord::Base


  def locate_appropriate_by_user_type(current_user)
    if current_user.is_student? && current_user.is_staff?
      task_types = TaskType.find(:all)
    end
    if current_user.is_student? && !current_user.is_staff?
      task_types = TaskType.find(:all, :conditions => ['is_student = ?', true])
    end
    if !current_user.is_student? && current_user.is_staff?
      task_types = TaskType.find(:all, :conditions => ['is_staff = ?', true])
    end
    if !current_user.is_student? && !current_user.is_staff?
      task_types = TaskType.find(:all)
    end
    return task_types
  end


end
