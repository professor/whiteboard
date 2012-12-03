# Deliverable is a zip or a file that the students submit for a course
#
# There are two ways for a student team to upload their deliverables.
#
# Way 1) On the curriculum pages for each task,  under the "Submitting Your Work" tab, there is a
# "submit your deliverable link" -- this gives the student the ability to name their deliverable, and upload a
# single attachment (i.e. one doc, ppt, or zip file) The student needs to mark whether this is an individual deliverable
# or team deliverable. By default a task number and the course number is provided for the student.
# If a faculty member tries to do this, they won't see any courses lists since they aren't taking the course as a student.
# Students can submit only team deliverable and one individual deliverable per task, although they can update the
# attachment as many times as they like.
#
# Every member of a team can see team deliverables, only the individual can see their individual deliverable.
#
# Way 2) A student team can upload their deliverable by clicking on "My Deliverables" on the left hand navigation and
# select "New" at the bottom of the page. This is a little less efficient because the student needs to select a
# course and assignment. It is a quick way for a student to see everything they have submitted for their courses.
#
# If a student or team accidentally uploads the wrong file, they can upload additional files. All files are
# kept in the system, but the convention is that the faculty will only examine the last uploaded file.
#
# The faculty assigned to that team will receive an email whenever a student submits a deliverable. The faculty
# can click on the email and provide either written comments in an text area or provide a file attachment back.
# If you annotate a word document you would upload the word document.
# If you annotate multiple files then you would attach a zip, just like the students do.
#
# If the faculty needs to see who has provided feedback or if they loose the email sent by the system, there is a f
# faculty interface for examining the deliverables. It is not perfect, it was developed by the students and they
# didn't have a strong sense of how we would use it. It currently shows all the deliverables submitted
# for a course sorted by recent changes first. There is no way to filter by faculty member, or sort by task,
# or sort by team, or sort by whether feedback has been provided. Control F in the browser is a life saver.
# It does show you which deliverables have been graded. In theory, just relying on the emails should be sufficient.

class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, :class_name => "User"
  belongs_to :assignment
  has_many :attachment_versions, :class_name => "DeliverableAttachment", :order => "submission_date DESC"
  has_many :deliverable_grades

  validates_presence_of :creator, :assignment
  validate :unique_course_task_owner?

  has_attached_file :feedback,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "deliverables/:course_year/:course_name/:random_hash/feedback/:id/:filename"

  default_scope :order => "created_at DESC"

  accepts_nested_attributes_for :deliverable_grades, allow_destroy: true

  before_save :populate_status
  after_save :create_deliverable_grade

  def course
    self.assignment.nil? ? nil : self.assignment.course
  end

  def course_id
    self.assignment.nil? ? nil : self.assignment.course_id
  end

  def task_number
    self.assignment.nil? ? nil : self.assignment.task_number.to_s
  end

  def unique_course_task_owner?
    if self.is_team_deliverable? && !self.team_id.blank?
      duplicate = Deliverable.where(:assignment_id => self.assignment_id, :team_id => self.team_id).first
      type = "team"
    else
      # Search for deliverable submitted by an individual.  It could be a team deliverable submitted by somebody not in
      # a team.
      duplicate = Deliverable.where(:assignment_id => self.assignment_id, :team_id => nil, :creator_id => self.creator_id).first
      type = "individual"
    end
    if duplicate && duplicate.id != self.id
      errors.add(:base, "Can't create another #{type} deliverable for the same assignment. Please edit the existing one.")
    end
  end

  def is_team_deliverable?
    self.assignment.blank? ? nil : self.assignment.team_deliverable
  end

  def current_attachment
    attachment_versions.first
  end

  def owner_name
    if self.is_team_deliverable?
      team.name
    else
      creator.human_name
    end
  end

  def owner_email
    if self.is_team_deliverable?
      self.team.nil? ? nil : team.email
    else
      creator.email
    end
  end

  def self.find_current_by_user(user)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    current_teams = Team.find_current_by_person(user)
    Deliverable.find_by_user_and_teams(user, current_teams)
  end

  def self.find_past_by_user(user)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    past_teams = Team.find_past_by_person(user)
    past_teams.blank? ? [] : Deliverable.find_by_user_and_teams(user, past_teams)
  end

  def self.find_by_user_and_teams(user, teams)
    team_condition = ""
    if !teams.empty?
      team_condition = "team_id IN ("
      team_condition << teams.collect { |t| t.id }.join(',')
      team_condition << ") OR "
    end
    Deliverable.find(:all, :conditions => team_condition + "(team_id IS NULL AND creator_id = #{user.id})")
  end

  def self.filter(filter_params = {})
    semester, year = filter_params[:semester_year].split('-')
    filter_criteria = {semester: semester, year: year, id: filter_params[:course_id]}
    courses = Course.where(filter_criteria)

    deliverables = []
    courses.each do |course|
      assignments =
        course.assignments.select do |assignment|
          filter_params[:assignment_id].blank? ? true : (assignment.id == filter_params[:assignment_id].to_i)
        end
      assignments.each do |assignment|
        deliverables.concat(
          assignment.deliverables.select do |deliverable|
            if filter_params[:submitted_by].blank?
              filter_params[:status] == deliverable.status
            else
              deliverable.creator.id == filter_params[:submitted_by].to_i && filter_params[:status] == deliverable.status
            end
          end
        )
      end
    end
    deliverables
  end

  def has_feedback?
    !self.feedback_comment.blank? or !self.feedback_file_name.blank? or self.status == 'Graded'
  end

  def send_deliverable_upload_email(url)
    mail_to = []
    unless self.team.nil? || self.team.primary_faculty.nil?
      mail_to << self.team.primary_faculty.email
    end
    unless self.team.nil? || self.team.secondary_faculty.nil?
      mail_to << self.team.secondary_faculty.email
    end

    if mail_to.empty?
      return
    end

    message = self.owner_name + " has submitted a deliverable for "
    if !self.task_number.nil? and self.task_number != ""
      message += "task " + self.task_number + " of "
    end
    message += self.course.name

    options = {:to => mail_to,
               :subject => "Deliverable submitted for " + self.course.name + " by " + self.owner_name,
               :message => message,
               :url_label => "View this deliverable",
               :url => url
    }
    GenericMailer.email(options).deliver
  end

  def send_deliverable_feedback_email(url)
    message = "Feedback has been submitted for "
    if !self.assignment && !self.assignment.task_number.blank?
      message += "task " + self.assignment.task_number + " of "
    end
    message += self.course.name

    if self.assignment.can_submit?
      mail_to = self.owner_email
      options = {:to => mail_to,
                 :subject => "Feedback for " + self.course.name,
                 :message => message,
                 :url_label => "View this deliverable",
                 :url => url
      }
      GenericMailer.email(options).deliver
    else
      self.deliverable_grades.each do |deliverable_grade|
        options = {:to => deliverable_grade.user.email,
                   :subject => "Feedback for " + self.course.name,
                   :message => message,
                   :url_label => "View this deliverable",
                   :url => url
        }
        GenericMailer.email(options).deliver
      end
    end
  end

  def editable?(current_user)
    if self.is_team_deliverable?
      unless self.team.is_user_on_team?(current_user)
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    if !self.is_team_deliverable?
      unless current_user == self.creator
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    return true
  end

  def update_team
    # Look up the team this user is on if it is a team deliverable
    Team.where(:course_id => self.course_id).each do |team|
      self.team = team if team.members.include?(self.creator)
    end
  end

  #{"Fall 2012"=>{"Architecture and Design"=>{deliverables: [#<Deliverable 1>, #<Deliverable 2>], total: 100}, ...}}
  def self.group_by_semester_course(deliverables, student)
    grouped_deliverables = {}
    deliverables.each do |deliverable|
      course = deliverable.assignment.course
      if !grouped_deliverables.has_key?(course.display_semester)
        grouped_deliverables[course.display_semester] = {}
      end
      if !grouped_deliverables[course.display_semester].has_key?(course.name)
        total_weight = course.total_assignment_weight
        earned_score = course.get_user_deliverable_grades(student).to_a.sum(&:number_grade)
        grouped_deliverables[course.display_semester][course.name] = {deliverables: [], max_score: total_weight, earned_score: earned_score}
      end
      grouped_deliverables[course.display_semester][course.name][:deliverables] << deliverable
    end
    return grouped_deliverables
  end

  private

  def populate_status
    if self.status.nil?
      self.status = "Ungraded"
    end
    true
  end

  def create_deliverable_grade
    if self.deliverable_grades.blank?
      if self.assignment.team_deliverable?
        self.course.teams.each do |team|
          if team.members.include?(self.creator)
            team.members.each do |member|
              self.deliverable_grades.create(grade: 0, user: member)
            end
            return
          end
        end
        # The student is not in any team.
        self.deliverable_grades.create(grade: 0, user: self.creator)
      else
        self.deliverable_grades.create(grade: 0, user: self.creator)
      end
    end
  end
end
