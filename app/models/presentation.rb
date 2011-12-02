class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :person, :foreign_key => :person_id

  has_many :feedbacks, :class_name => 'PresentationFeedback', :foreign_key => :presentation_id

  validates_presence_of :name, :presentation_date, :task_number

  accepts_nested_attributes_for :feedbacks

  def self.find_ratings (feedbacks, questions)

    #code for ratings
	presentation_answers = []
	question_ratings = Hash.new
	ratings= []

	feedbacks.each do|f|
        feedback_answers = PresentationFeedbackAnswer.find(:all, :conditions => {:feedback_id => f.id})
        presentation_answers << feedback_answers
	end

	questions.each do |q|
	    unless q.is_deleted?
	    	question_ratings[q.id] = [0,0,0,0]
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
	  unless q.is_deleted?

		comments = " "
		found_answers = PresentationFeedbackAnswer.where(:feedback_id => feedback_ids, :question_id => q.id)
		found_answers.each do |f|
		   unless (f.comment == "")  || (f.comment.nil?)
			 comments = comments + "*- " + f.comment
		   end
		end
	    question_comments[q.id] = comments
	  end
	end
	return question_comments
  end

  def person_email
    if !self.team_id.nil?
      self.team.email
    else
      self.person.email
    end
  end

  def send_presentation_feedback_email(url)

    mail_to = self.person_email
    message = "Feedback has been submitted for presentation"
    message += self.name + " for " + self.course.name

    options = {:to => mail_to,
               :subject => self.course.name + ": Feedback for presentation " +  self.name,
               :message => message,
               :url_label => "View feedback",
               :url => url
    }
    GenericMailer.email(options).deliver
  end

end
