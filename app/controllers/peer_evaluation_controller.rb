class PeerEvaluationController < ApplicationController
  layout 'cmu_sv'
  before_filter :authenticate_user!

  @@questions = [
      "What was this team member's most significant positive contribution to the team?",
      "In what ways could this team member improve his/her contribution to team meetings?",
      "In what ways could this team member improve his/her contribution to the team's deliverables? ",
      "Please provide feedback on the progress of each individual's improvement objective:"
  ]
  @@point_allocation = "Point allocations"

  def index_for_course
    @course = Course.find(params[:course_id])
    authorize! :peer_evaluation, @course

    @teams = Team.where(:course_id => params[:course_id])
  end

  def edit_setup
    if has_permissions_or_redirect(:staff, root_path)
      @team = Team.find(params[:id])
      @users = @team.members

      @objective = PeerEvaluationLearningObjective.new

      @objectives = []
      @team.members.each do |member|
        objective = PeerEvaluationLearningObjective.where(:team_id => @team.id, :user_id => member.id).first
        if objective.nil?
          @objectives << PeerEvaluationLearningObjective.new
        else
          @objectives << objective
        end
      end
    end
  end

  def complete_setup
    if has_permissions_or_redirect(:staff, root_path)
      @team = Team.find(params[:id])

      counter = 0
      @team.members.each do |member|
        if (PeerEvaluationLearningObjective.where(:team_id => @team.id, :user_id => member.id).first.nil?)
          @objective = PeerEvaluationLearningObjective.new(
              :team_id => params[:id],
              :user_id => member.id,
              :learning_objective => params[:peer_evaluation_learning_objective][counter.to_s][:learning_objective]
          )
        else
          @objective = PeerEvaluationLearningObjective.where(:team_id => @team.id, :user_id => member.id).first
          @objective.learning_objective = params[:peer_evaluation_learning_objective][counter.to_s][:learning_objective]
        end

        @objective.save!
        counter += 1
      end

      flash[:notice] = "Learning objectives have been updated."
      redirect_to(peer_evaluation_path(@team.course, @team.id))
    end
  end


  def edit_evaluation
    @questions = @@questions
    @team = Team.find(params[:id])
    @users = @team.members
    @author = User.find(current_user.id)
    @answers = []
    @point_allocations = {}
    @review = PeerEvaluationReview.new

    @on_team = false
    @users.each do |user|
      if (user.human_name == current_user.human_name)
        @on_team = true
      end
    end

    if (@on_team == false)
      if (current_user.is_staff || current_user.is_admin)
        return
      end
      flash[:error] = "You are not on team #{@team.name}"
      redirect_to(peer_evaluation_path(@team.course, @team.id))
      return
    end

    @users.each do |user|
      @questions.each do |question|
        evaluation = PeerEvaluationReview.where(:author_id => @author.id, :recipient_id => user.id, :team_id => @team.id, :question => question).first
        if (evaluation.nil?)
          @answers << ""
        else
          @answers << evaluation.answer
        end
      end
    end

    allocation = PeerEvaluationReview.where(:author_id => @author.id, :team_id => @team.id, :question => @@point_allocation).first
    unless allocation.nil? || allocation.answer.nil?
      match_array = allocation.answer.scan /((\w| )*):(\d*)\s*/
      match_array.each do |match|
        name = match[0]
        points = match[2]
        @point_allocations[name] = points
      end
    end
  end


  def complete_evaluation
    @questions = @@questions

    @team = Team.find(params[:id])
    @users = @team.members

    @author = User.find(current_user.id)

    user_counter = 0
    question_counter = 0
    @users.each do |user|
      @questions.each do |question|
        @evaluation = PeerEvaluationReview.where(:author_id => @author.id, :recipient_id => user.id, :team_id => @team.id, :question => question).first
        if (@evaluation.nil?)
          @evaluation = PeerEvaluationReview.new(
              :author_id => @author.id,
              :recipient_id => user.id,
              :team_id => @team.id,
              :question => question,
              :answer => params[:peer_evaluation_review][(@questions.size*user_counter + question_counter).to_s][:answer],
              :sequence_number => question_counter
          )
        else
          @evaluation.answer = params[:peer_evaluation_review][(@questions.size*user_counter + question_counter).to_s][:answer]
        end
        @evaluation.save!
        question_counter += 1
      end

      user_counter += 1
      question_counter = 0
    end

    alloc_counter = 0
    alloc_answer = ""
    @users.each do |user|
      alloc_answer << user.human_name + ":" + params[:allocations][alloc_counter.to_s] + " "
      alloc_counter += 1
    end

    allocation = PeerEvaluationReview.where(:author_id => @author.id, :team_id => @team.id, :question => @@point_allocation).first
    if (allocation.nil?)
      allocation = PeerEvaluationReview.new(
          :author_id => @author.id,
          :team_id => @team.id,
          :question => @@point_allocation,
          :answer => alloc_answer,
          :sequence_number => question_counter
      )
    else
      allocation.answer = alloc_answer
    end
    allocation.save!

    flash[:notice] = "Thank you for completing the peer evaluation form."
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end

  def complete_evaluation_update    
    @questions = @@questions

    @team = Team.find(params[:id])
    @users = @team.members

    @author = User.find(current_user.id)

    if (params[:peer_evaluation_review])
      field_id    = params[:peer_evaluation_review].first[0].to_i
      question_id = field_id % @questions.size
      question    = @questions[question_id]
      user_id     = (field_id / (@users.size.to_i + 1)).ceil
      user        = @users[user_id]
      @evaluation = nil
      if question && question_id && user.id && @author.id && @team.id
        @evaluation = PeerEvaluationReview.where(:author_id => @author.id, :recipient_id => user.id, :team_id => @team.id, :question => question).first
        
        if @evaluation.nil?
           @evaluation = PeerEvaluationReview.new(
                  :author_id => @author.id,
                  :recipient_id => user.id,
                  :team_id => @team.id,
                  :question => question,
                  :answer => params[:peer_evaluation_review][field_id.to_s][:answer],
                  :sequence_number => question_id
              )
        else
          @evaluation.answer = params[:peer_evaluation_review][field_id.to_s][:answer]
        end
        unless @evaluation.save!
          head :internal_server_error
          return
        end
      end
    end

    alloc_answer = ""
    if (params[:allocations] && params[:allocations].first && params[:allocations].first[0])
      user_position = params[:allocations].first[0]
      user = @users[user_position.to_i]
      allocation = PeerEvaluationReview.where(:author_id => @author.id, :team_id => @team.id, :question => @@point_allocation).first
      user_allocs = []

      if (allocation.nil?)
        alloc_answer << user.human_name + ":" + params[:allocations][user_position] + " "
        allocation = PeerEvaluationReview.new(
            :author_id => @author.id,
            :team_id => @team.id,
            :question => @@point_allocation,
            :answer => alloc_answer,
            :sequence_number => user_position
        )
      else
        # pull the string out of the database and parse it into an array
        # keeping the users in order
        match_array = allocation.answer.scan /((\w| )*):(\d*)\s*/
        match_array.each_with_index do |match, index|
          name = match[0]
          points = match[2]
          user_positions = @users.map{|u| u.human_name == name}
          user_allocs[user_positions.index(true)] = {name => points}
        end
        # update the values for the value given via ajax in the correct position and make it a string again
        user_allocs[user_position.to_i] = {user.human_name => params[:allocations][user_position]}
        user_allocs.each do |user_alloc|
          unless user_alloc.nil?
          alloc_answer << user_alloc.first[0] + ":" + user_alloc.first[1] + " "
          end
        end

        allocation.answer = alloc_answer
      end
      unless allocation.save!
          head :internal_server_error
          return
        end
    end

    render :nothing => true
  end

  def edit_report
    if has_permissions_or_redirect(:staff, root_path)
      @team = Team.find(params[:id])
      @users = @team.members

      @report = PeerEvaluationReport.new

      @incompletes = Array.new
      @team.members.each do |member|
        unless PeerEvaluationReview.is_completed_for?(member.id, @team.id)
          @incompletes << (member)
        end
      end

      @reportArray = Array.new(@users.size)
      user_counter = 0
      @users.each do |user|
        @reportArray[user_counter] = generate_report_for_student(user.id, @team.id)
        user_counter += 1
      end

      @report_allocations = {}
      @point_allocations = Hash.new { |hash, key| hash[key] = {} } #two dimensional hash
      @users.each do |user|
        allocation = PeerEvaluationReview.where(:author_id => user.id, :team_id => @team.id, :question => @@point_allocation).first
        unless allocation.nil?
          @report_allocations[user.human_name] = allocation.answer

          match_array = allocation.answer.scan /((\w| )*):(\d*)\s*/
          match_array.each do |match|
            name = match[0]
            points = match[2]
            @point_allocations[user.human_name][name] = points
          end
        end
      end
    end
  end

  def complete_report
    if has_permissions_or_redirect(:staff, root_path)
      if params[:commit] == "Save And Email All"
        send_email = true
      else
        send_email = false
      end

      @team = Team.find(params[:id])
      @users = @team.members
      @users.each do |user|
        #Step 1 save feedback
        feedback = params[:peer_evaluation_report][user.id.to_s][:feedback]
        report = PeerEvaluationReport.where(:recipient_id => user.id, :team_id => @team.id).first
        if report.nil?
          report = PeerEvaluationReport.new(:recipient_id => user.id, :team_id => @team.id, :feedback => feedback)
        else
          report.feedback = feedback
        end
        report.save!

        faculty = @team.faculty_email_addresses()
        #Step 2 email feedback
        if send_email
          options = {:to => user.email, :cc => faculty, :subject => "Peer evaluation feedback from team #{@team.name}",
                     :message => feedback.gsub("\n", "<br/>"), :url => "", :url_label => ""}
          GenericMailer.email(options).deliver
          report.email_date = Time.now
          report.save!
        end
      end

      flash[:notice] = "Reports have been successfully saved."
      redirect_to(peer_evaluation_path(@team.course, @team.id))
    end
  end


  def email_reports

  end


  def create_please_do_evaluation_email

    teams = Team.all
    emails_sent = 0

    #teams = Team.find(:all, :conditions => ["id = ? ", "215"])
    teams.each do |team|
      #puts "Team: " + team.name + " (" + team.id.to_s + ") "
      unless team.peer_evaluation_first_email.nil? && team.peer_evaluation_second_email.nil?
        first_date_p = Date.today == team.peer_evaluation_first_email.to_date unless team.peer_evaluation_first_email.nil?
        second_date_p = Date.today == team.peer_evaluation_second_email.to_date unless team.peer_evaluation_second_email.nil?
        if ((first_date_p) ||
            (second_date_p))

          puts "Team: " + team.name + " (" + team.id.to_s + ") "
          puts "First email date: " + team.peer_evaluation_first_email.to_s
          puts "Second email date: " + team.peer_evaluation_second_email.to_s
          puts "Today: " + Date.today.to_s
          puts "1st comparison is true " if Date.today == team.peer_evaluation_first_email.to_date
          puts "2nd comparison is true " if Date.today == team.peer_evaluation_second_email.to_date
          puts ""

          #from_address = "scotty.dog@sv.cmu.edu"
          faculty = team.faculty_email_addresses()

          if first_date_p
            to_address = team.email
            to_address = []
            team.members.each do |user|
              to_address << user.email
            end
            send_email(team, faculty, to_address, team.peer_evaluation_message_one)
            emails_sent += 1
          elsif second_date_p
            to_address_done = []
            to_address_incomplete = []
            team.members.each do |user|
              if PeerEvaluationReview.is_complete_for?(user_id, team_id)
                to_address_done << user.email
              else
                to_address_incomplete << user.email
              end
            end
            send_email(team, faculty, to_address_done, team.peer_evaluation_message_two_done)
            send_email(team, faculty, to_address_incomplete, team.peer_evaluation_message_two_incomplete)
            emails_sent += 2
          end

        end
      end
    end

    return emails_sent
  end


  private
  def send_email(team, faculty, to_address, message)
    options = {:to => to_address, :cc => faculty, :bcc => "rails.app@sv.cmu.edu",
               :subject => "peer evaluation for team #{team.name}",
               :message => message, :url => "http://rails.sv.cmu.edu/peer_evaluation/edit_evaluation/#{team.id}", # + edit_peer_evaluation_path(team))
               :url_label => "Complete the survey now"}
    GenericMailer.email(options).deliver
  end


  def generate_report_for_student(user_id, team_id)
    report = PeerEvaluationReport.where(:recipient_id => user_id, :team_id => team_id).first
    if report.nil?
      report_string = ""
      #report_string += "{" + user.human_name + "}\n"
      question_counter = 0
      @@questions.each do |question|
        report_string += question + "\n"
        if question_counter == @@questions.size - 1
          learning_objective = PeerEvaluationLearningObjective.where(:user_id => user_id).first
          report_string += "\"" + learning_objective.learning_objective + "\"\n" unless (learning_objective.nil? || learning_objective.learning_objective.nil? || learning_objective.learning_objective.empty?)
        end
        data = PeerEvaluationReview.where(:team_id => team_id, :recipient_id => user_id, :question => question).all
        data.each do |answer|
          author = User.find(answer.author_id).human_name
          report_string += "[" + author + "]\n"
          report_string += " - " + answer.answer + "\n"
        end
        report_string += "\n"
        question_counter += 1
      end
      return report_string
    else
      return report.feedback
    end

  end


end
