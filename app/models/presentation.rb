class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :user, :foreign_key => :user_id

  has_many :feedbacks, :class_name => 'PresentationFeedback', :foreign_key => :presentation_id

  validates_presence_of :name, :presentation_date
  validate :team_or_user_for_presenter?

  accepts_nested_attributes_for :feedbacks

  def team_or_user_for_presenter?
    if team_id.blank? && user_id.blank?
      errors.add(:base, "Can't create a presentation without a team or person giving it")
    end
  end

  def is_team_presentation?
    !self.team.blank?
  end

  def presenter
    if self.is_team_presentation?
      team.name
    else
      user.human_name
    end
  end
  
  def presenter?(current_user)
    current_user == self.user || current_user.teams.include?(team)
  end

  def has_given_feedback?(user)
    @presentation_feedbacks = PresentationFeedback.where("evaluator_id = :uid AND presentation_id = :pid",
          {:uid => user.id, :pid => self.id})

    if @presentation_feedbacks[0] == nil
      return false
    else
      return true
    end
  end

  def self.find_by_presenter(current_user)
    # Find everything where the passed in person is either the assignee
    # or is on the presentation's team
    teams = Team.find_by_person(current_user)
    Presentation.find_by_user_and_teams(current_user, teams)
  end

  def self.find_by_user_and_teams(current_user, teams)
    team_condition = ""
    if !teams.empty?
      team_condition = "team_id IN ("
      team_condition << teams.collect { |t| t.id }.join(',')
      team_condition << ") OR "
    end
    Presentation.where(team_condition + "(team_id IS NULL AND user_id = #{current_user.id})")
  end    

  def can_view_feedback?(user)
    if presenter?(user) || user.is_staff? || user.is_admin
      return true
    end
    return false
  end    

  def self.find_ratings (feedbacks, questions)

    #code for ratings
    presentation_answers = []
    question_ratings = Hash.new
    ratings= []

    feedbacks.each do |f|
      feedback_answers = PresentationFeedbackAnswer.find(:all, :conditions => {:feedback_id => f.id})
      presentation_answers << feedback_answers
    end

    questions.each do |q|
      unless q.deleted?
        question_ratings[q.id] = [0, 0, 0, 0]
      end
    end

    presentation_answers.each do |a|
      a.each do |ans|
        ratings = question_ratings[ans.question_id]
        ratings[ans.rating-1] += 1
      end
    end
    return question_ratings
  end

  def self.find_comments (feedbacks, questions)

    # code for comments

    feedback_ids = []
    question_comments = Hash.new

    feedbacks.each do |f|
      feedback_ids << f.id
    end

    questions.each do |q|
      unless q.deleted?

        comments = " "
        found_answers = PresentationFeedbackAnswer.where(:feedback_id => feedback_ids, :question_id => q.id)
        found_answers.each do |f|
          unless (f.comment == "") || (f.comment.nil?)
            comments = comments + "*- " + f.comment
          end
        end
        question_comments[q.id] = comments
      end
    end
    return question_comments
  end

  def user_email
    if !self.team_id.nil?
      self.team.email
    else
      self.user.email
    end
  end

  def send_presentation_feedback_email(url)

    mail_to = self.user_email
    message = "See feedback for your presentation "
    message += self.name + " for " + self.course.name

    subject = ""
    subject = subject + self.course.short_name unless self.course.short_name.nil?
    subject = subject + "Feedback for presentation " + self.name

    options = {:to => mail_to,
               :subject => subject,
               :message => message,
               :url_label => "View feedback",
               :url => url
    }
    GenericMailer.email(options).deliver
  end

end
