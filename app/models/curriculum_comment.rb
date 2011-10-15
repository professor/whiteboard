class CurriculumComment < ActiveRecord::Base
  belongs_to :user, :class_name=>"User", :foreign_key=>"user_id"
  belongs_to :type, :class_name=>"CurriculumCommentType", :foreign_key=>"curriculum_comment_type_id"

  validates_presence_of :comment

  def editable(current_user)
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
    curriculum_comments = CurriculumComment.find(:all, :conditions => ["url = ? and notify_me = true and user_id is not null", self.url])
    email_addresses = []
    curriculum_comments.each { |comment| email_addesses << curriculum_commments.user.email_address }
    return email_addresses
  end


  def notify_instructors()
    instructors = []
    return instructors if self.url.empty?

    if self.url.include? "architecture_se"
      instructors << "Todd.Sedano@sv.cmu.edu"
      instructors << "Reed.Letsinger@sv.cmu.edu"
      instructors << "Ed.Katz@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "mfse"
      instructors << "Martin.Radley@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "ppm"
      instructors << "Martin.Radley@sv.cmu.edu"
      instructors << "Gladys.Mercier@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "/msp/"
      instructors << "Martin.Radley@sv.cmu.edu"
      instructors << "Gladys.Mercier@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "foundations_agile"
      instructors << "Todd.Sedano@sv.cmu.edu"
      instructors << "Ed.Katz@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "requirements_se"
      instructors << "Reed.Letsinger@sv.cmu.edu"
      instructors << "Patricia.Collins@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "/esm/"
      instructors << "Gladys.Mercier@sv.cmu.edu"
      instructors << "Patricia.Collins@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "mfsm"
      instructors << "Gladys.Mercier@sv.cmu.edu"
      instructors << "Patricia.Collins@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "/sps/"
      instructors << "Ray.Bareiss@sv.cmu.edu"
      instructors << "Tony.Wasserman@sv.cmu.edu"
      return instructors
    end
    if self.url.include? "/spd/"
      instructors << "Ray.Bareiss@sv.cmu.edu"
      instructors << "Tony.Wasserman@sv.cmu.edu"
      return instructors
    end

    instructors << "Todd.Sedano@sv.cmu.edu"
    return instructors

  end


end